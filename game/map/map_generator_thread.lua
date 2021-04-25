-- this is a love thread
require "settings"
Vector = require "lib.hump.vector"
Class = require "lib.hump.class"
Utils = require "engine.utils.utils"
Resources = require "game.map.resources"
require 'love.timer'
require 'engine.utils.debug'
serpent = require "lib.serpent.serpent"
require "love.math"
local log = require 'engine.utils.logger' ("mapGenerator", function(msg) return "[mapGenerator thread]: " .. msg end)

local mapGeneratorWorker = require "game.map.map_generator_worker" ()

local running = true

local inputChannel = love.thread.getChannel("mapGeneratorControl")
local outputChannel = love.thread.getChannel("mapGeneratorOutput")

local priorityQueue = {}

local function schedule(priority, task)
    if not priority then priority = 5 end
    if not priorityQueue[priority] then
        priorityQueue[priority] = {}
    end
    table.insert(priorityQueue[priority], task)
end

local function cancel(task)
    for priority, tasks in pairs(priorityQueue) do
        for i, scheduledtask in pairs(tasks) do
            if scheduledtask.chunkPosition == task.chunkPosition then
                tasks[i] = nil
                return true
            end
        end
    end
    return false
end

local function popNextTask()
    for priority, tasks in pairs(priorityQueue) do
        for i, task in pairs(tasks) do
            tasks[i] = nil
            return task
        end
        priorityQueue[priority] = nil
    end
end

local function doOneTask()
    local task = popNextTask()
    if not task then log(5, "No tasks in list") return false end
    log(3, "Starting task", task)
    local chunk = mapGeneratorWorker:generateChunk(task.chunkPosition, task.chunkDiff)
    log(5, "Chunk generated:", chunk)
    outputChannel:push({ type = "chunk", data = { chunk = chunk, position = task.chunkPosition } })
    return true
end

local function handleTask(task)
    log(5, "Got task: " .. task.command )
    if task.command == "generate" then
        schedule(task.priority, task)
    elseif task.command == "cancel" then
        cancel(task)
    elseif task.command == "terminate" then
        running = false
    end
end

while running do
    while inputChannel:peek() do
        local task = inputChannel:pop()
        if task.command then
            handleTask(task)
        end
    end
    if not doOneTask() then
        log(5, "sleeping")
        love.timer.sleep(0.001)
    end
end
