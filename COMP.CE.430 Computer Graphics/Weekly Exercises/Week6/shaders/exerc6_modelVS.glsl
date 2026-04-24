#version 460

uniform mat4 matVP;
uniform mat4 matGeo;

out vec3 vertexPos;
out vec3 textCoord;
out vec3 vertexNormal;
out vec4 vertexColor;
out vec4 color;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 texcoord;
layout (location = 2) in vec3 normal;
layout (location = 3) in vec3 in_color;

void main() {
   color = vec4(abs(normal), 1.0);
   gl_Position = matVP * matGeo * vec4(pos, 1);
   
   // Send data to fragshader
   vertexPos = (matGeo * vec4(pos, 1)).xyz;
   textCoord = texcoord;
   vertexNormal = normal;
   vertexColor = vec4(in_color, 1.0);
}