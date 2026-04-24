#version 460

uniform vec2 uResolution;
uniform float uTime;

layout(location=0) in vec3 in_color;

out vec4 outColor;

void main()
{
    vec2 uv = gl_FragCoord.xy/uResolution;
    outColor = vec4(in_color, 1);
}