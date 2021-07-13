extern number intensity;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 c = Texel(texture, texture_coords);
    return vec4(c.r + (1-c.r)*intensity, c.g + (1-c.g)*intensity, c.b + (1-c.b)*intensity, c.a);
}