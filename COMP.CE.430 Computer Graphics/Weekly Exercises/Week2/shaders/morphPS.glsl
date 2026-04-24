#version 460

layout(location=0) in vec3 in_color;
out vec4 outColor;

void main()
{
	vec3 color = normalize(in_color);
    outColor = vec4(color.x,
    				color.y,
    				color.z,
    				1);
}