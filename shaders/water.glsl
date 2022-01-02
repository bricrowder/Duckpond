extern number time;
extern number starta;

//Modify the following three consts to change the wave effect to your liking
const number xSpeed = 0.5;
const number xFreq = 10.0;
const number xSize = 0.005;
const number ySpeed = 0.5;
const number yFreq = 50.0;
const number ySize = 0.0025;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    number xWave = sin(time * xSpeed + tc.y * xFreq) * xSize;
    number yWave = cos(time * ySpeed + tc.x * yFreq) * ySize;
    vec4 c = color * Texel(tex, tc + vec2(xWave, yWave));
    c.a = starta * tc.y; 
    return c; 
}