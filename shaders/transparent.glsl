extern number starta;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    vec4 c = color * Texel(tex, tc);
    c.a = starta * tc.y; 
    return c; 
}