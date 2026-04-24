#version 460

uniform mat4 matVP;
uniform mat4 matGeo;
uniform float uTime;
uniform vec3 cameraPos;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec3 inColor;

out vec3 vertexPos;
out vec3 vertexNormal;
out vec4 vertexColor;

// Viewport matrix
uniform vec2 viewPortSize;
const float planeNear = 0.1;
const float planeFar = 1000.0;
mat4 viewPortMatrix;
mat4 calcViewPortMatrix();

mat4 mat4Identity();

// Camera
mat4 cameraMatrix;
mat4 calcCameraMatrix();

void main() {
   // Viewport matrix
   viewPortMatrix = calcViewPortMatrix();
   cameraMatrix = calcCameraMatrix();
   mat4 mat = mat4Identity();
	gl_Position = viewPortMatrix * cameraMatrix * matGeo * vec4(pos, 1);
	
   // Send data to fragshader
   vertexPos = (matGeo * vec4(pos, 1)).xyz;
   // Fix normal vector
   vertexNormal = normalize(transpose(inverse(mat)) * vec4(normal, 0.0)).xyz;
   vertexColor = vec4(inColor, 1.0);
}

mat4 calcViewPortMatrix(){
	mat4 mat;
	float a = viewPortSize.x / viewPortSize.y;
	
	mat[0] = vec4(1/(a*tan(a/2)), 0.0, 0.0,  0.0);
	mat[1] = vec4(0.0, 1/(tan(a/2)), 0.0,  0.0);
	mat[2] = vec4(0.0, 0.0, -(planeFar+planeNear)/(planeFar-planeNear), -1.0);
	mat[3] = vec4(0.0, 0.0, -(2*planeFar*planeNear)/(planeFar-planeNear), 0.0);
	
	return mat;
}

mat4 calcCameraMatrix(){
	mat4 mat;
	
	vec3 Z = normalize(cameraPos);
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 X = normalize(cross(up, Z));
	vec3 Y = cross(Z, X);
	
	mat[0] = vec4(X, 0.0);
	mat[1] = vec4(Y, 0.0);
	mat[2] = vec4(Z, 0.0);
	mat[3] = vec4(cameraPos, 1.0);
	
	return inverse(mat);
}

mat4 mat4Identity(){
	mat4 mat;
	mat[0] = vec4(1, 0, 0, 0);
	mat[1] = vec4(0, 1, 0, 0);
	mat[2] = vec4(0, 0, 1, 0);
	mat[3] = vec4(0, 0, 0, 1);
	return mat;
}