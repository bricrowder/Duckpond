extern number time;
extern number height;

//Modify the following three consts to change the wave effect to your liking
const number xSpeed = 1;
const number xFreq = 25.0;
const number xSize = 0.015;
const number ySpeed = 2;
const number yFreq = 175.0;
const number ySize = 0.005;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    number xWave = sin(time * xSpeed + tc.y * xFreq) * xSize;
    number yWave = cos(time * ySpeed + tc.x * yFreq) * ySize;
    color.a = (height - tc.y) / height;
    return color * Texel(tex, tc + vec2(xWave, yWave));
}