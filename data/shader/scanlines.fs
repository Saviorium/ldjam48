extern number time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 c = Texel(texture, texture_coords);
    return vec4(c.r + (1-c.r)*sin(time), c.g + (1-c.g)*sin(time), c.b + (1-c.b)*sin(time), c.a);
}