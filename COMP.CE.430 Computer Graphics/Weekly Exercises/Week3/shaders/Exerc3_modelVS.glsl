#version 460

uniform float uTime;
uniform mat4 viewProj;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec4 normals;

out vec3 vertexNormal;
out vec3 vertexPos;

void main() {
	gl_Position = viewProj * vec4(pos.x,
								  pos.y,
								  pos.z,
								  0.3);
	vertexNormal = vec3(normals);
	vertexPos = pos;
}
