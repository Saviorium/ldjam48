function love.conf(t)
    t.window.width = 1366
    t.window.height = 768
    t.window.title = "Deeper and Deeper Mining Operations ltd."
    t.window.vsync = 1
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

    local FixedFPS = 60
    local framesCount = 0
    local timer = 0
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = dt + love.timer.step() end

        timer = timer + love.timer.getDelta()

        if dt >= 1/FixedFPS then

            framesCount = framesCount + 1
            if timer >= 1 then
                print(framesCount, love.timer.getFPS())
                framesCount = 0
                timer = 0
            end

            -- Call update and draw
            if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()
                love.graphics.clear(love.graphics.getBackgroundColor())

                if love.draw then love.draw() end

                love.graphics.present()
            end

            dt = 0
        end

        if love.timer then love.timer.sleep(0.001) end
	end
end