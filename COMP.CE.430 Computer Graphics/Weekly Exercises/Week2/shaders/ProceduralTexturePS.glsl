#version 460

uniform float uTime;

layout(location=0) in vec3 in_color;
layout(location=2) in vec2 uv;

out vec4 outColor;

void main()
{
	vec3 color = normalize(in_color);
	
    outColor = vec4(int(255*uv.y) % 2,
    				int(100*uv.x) % 2,
    				int(100*uv.x) % 2,
    				1.0);
}