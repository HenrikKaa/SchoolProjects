#version 460

uniform mat4 matVP;
uniform mat4 matGeo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec3 inColor;

out vec3 vertexPos;
out vec3 vertexNormal;
out vec4 vertexColor;

void main() {
   gl_Position = matVP * vec4(pos, 0.33);
   
   vertexPos = pos;
   vertexNormal = normal;
   vertexColor = vec4(inColor, 1.0);
}
