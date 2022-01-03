extern number time;

const number xSpeed = 0.5;
const number xFreq = 25.0;
const number xSize = 0.005;
const number ySpeed = 0.5;
const number yFreq = 50.0;
const number ySize = 0.005;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    number xWave = sin(time * xSpeed + tc.y * xFreq) * xSize;
    number yWave = cos(time * ySpeed + tc.x * yFreq) * ySize;
    return color * Texel(tex, tc + vec2(xWave, yWave));
}