#version 460

uniform vec2 uViewPortSize;

layout(location=0) in vec3 in_color;

out vec4 outColor;

void main()
{
	vec2 pos = vec2(
					gl_FragCoord.x/uViewPortSize.x,
					gl_FragCoord.y/uViewPortSize.y
	);
    outColor = vec4(1.0,
    				1-3*distance(pos, vec2(0.5, 0.5)),
    				0.1,
    				1);
}