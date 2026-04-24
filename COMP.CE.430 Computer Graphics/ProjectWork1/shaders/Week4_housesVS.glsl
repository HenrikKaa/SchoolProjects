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
mat4 projectionMatrix;
mat4 calcProjectionMatrix();

// Camera
mat4 viewMatrix;
mat4 calcViewMatrix();

// Translate, scale, rotate
mat4 translate(vec3 t);
mat4 scale(vec3 s);
mat4 rotate(int axis, float t);

void main() {         
   // Create matrices
   mat4 rotateX = rotate(0, float(1+gl_InstanceID)*uTime/20.0);
   mat4 rotateY = rotate(1, float(1+gl_InstanceID)*uTime/5.0);
   mat4 rotateZ = rotate(2, float(1+gl_InstanceID)*uTime/10.0);
   int id = gl_InstanceID+1;
   vec3 scaler = vec3(2+sin(uTime/5.0*id), 2+sin(uTime/5.0*id), 2+sin(uTime/5.0*id));
   float orbit_dist = gl_InstanceID + 10;
   mat4 transl = translate(vec3(orbit_dist, 0.0, 0.0)) * scale(scaler);
   
   // Viewport matrix
   projectionMatrix = calcProjectionMatrix();
   viewMatrix = calcViewMatrix();
   
   // And apply
   mat4 mat = rotateZ * rotateX * rotateY * transl;
   gl_Position = projectionMatrix * viewMatrix * mat * vec4(pos, 1);
   
   // Send data to fragshader
   vertexPos = vec4(mat * vec4(pos, 1)).xyz;
   // Fix normal vector
   vertexNormal = normalize(transpose(inverse(mat)) * vec4(normal, 0.0)).xyz;
   vertexColor = vec4(inColor, 1.0);
}

mat4 calcProjectionMatrix(){
	mat4 mat;
	float a = viewPortSize.x / viewPortSize.y;
	
	mat[0] = vec4(1/(a*tan(a/2)), 0.0, 0.0,  0.0);
	mat[1] = vec4(0.0, 1/(tan(a/2)), 0.0,  0.0);
	mat[2] = vec4(0.0, 0.0, -(planeFar+planeNear)/(planeFar-planeNear), -1.0);
	mat[3] = vec4(0.0, 0.0, -(2*planeFar*planeNear)/(planeFar-planeNear), 0.0);
	
	return mat;
}

mat4 calcViewMatrix(){
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

mat4 translate(vec3 t){
	mat4 mat;
	mat[0] = vec4(1.0, 0.0, 0.0, 0.0);
	mat[1] = vec4(0.0, 1.0, 0.0, 0.0);
	mat[2] = vec4(0.0, 0.0, 1.0, 0.0);
	mat[3] = vec4(t.xyz, 1.0);
	
	return mat;
}

mat4 scale(vec3 s){
	mat4 mat;
	mat[0] = vec4(s.x, 0.0, 0.0, 0.0);
	mat[1] = vec4(0.0, s.y, 0.0, 0.0);
	mat[2] = vec4(0.0, 0.0, s.z, 0.0);
	mat[3] = vec4(0.0, 0.0, 0.0, 1.0);
	
	return mat;
}

// x=0, y=1,z=2
mat4 rotate(int axis, float t){
	mat4 mat;
	if(axis == 0){
		mat[0] = vec4(1.0,     0.0,    0.0, 0.0);
		mat[1] = vec4(0.0,  cos(t), sin(t), 0.0);
		mat[2] = vec4(0.0, -sin(t), cos(t), 0.0);
	} else if(axis == 1){
		mat[0] = vec4(cos(t), 0.0, -sin(t), 0.0);
		mat[1] = vec4(   0.0, 1.0,     0.0, 0.0);
		mat[2] = vec4(sin(t), 0.0,  cos(t), 0.0);
	} else if(axis==2) {
		mat[0] = vec4( cos(t), sin(t), 0.0, 0.0);
		mat[1] = vec4(-sin(t), cos(t), 0.0, 0.0);
		mat[2] = vec4(    0.0,    0.0, 1.0, 0.0);
	}
	
	mat[3] = vec4(0.0, 0.0, 0.0, 1.0);
	return mat;
}