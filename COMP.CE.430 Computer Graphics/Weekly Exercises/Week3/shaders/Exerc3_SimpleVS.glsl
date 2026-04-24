#version 460

uniform vec2 uResolution;
uniform float uTime;

layout(location=0) out vec3 out_color;

layout (location = 0) in vec2 pos;
const vec3 colors[3] = {
	vec3(1,1,1),
	vec3(0,1,1),
	vec3(0,0,1)
};

void main() {
	gl_Position = vec4(pos.x+sin((gl_VertexID+1)*uTime),
					   pos.y+cos((gl_VertexID-1)*uTime),
					   0,
					   3);
	
	out_color = colors[gl_VertexID];
}
