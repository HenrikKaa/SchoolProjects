#version 460

uniform float uTime;
uniform mat4 viewProj;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec4 normals;

layout(location=0) out vec3 out_color;

void main() {
	// Morph into a cube
	vec3 cubePos = vec3(
						pos.x,
						pos.y,
						pos.z
	);
	
	if(abs(cubePos.x) > abs(cubePos.y) && abs(cubePos.x) > abs(cubePos.z)){
		cubePos.x = sign(cubePos.x);
	} else if(abs(cubePos.y) > abs(cubePos.z)){
		cubePos.y = sign(cubePos.y);
	} else {
		cubePos.z = sign(cubePos.z);
	}
	
	float limit = 0.5;
	if(cubePos.x > limit){
		cubePos.x = sign(cubePos.x);
	}
	if(cubePos.y > limit){
		cubePos.y = sign(cubePos.y);
	}
	if(cubePos.z > limit){
		cubePos.z = sign(cubePos.z);
	}
						
	vec3 outpos = mix(pos, cubePos, (sin(uTime)+1)/2);
	gl_Position = viewProj * vec4(outpos, 0.3);
	
	out_color = vec3(normals);
}
