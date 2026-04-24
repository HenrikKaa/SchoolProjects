#version 460

in vec3 vertexNormal;
in vec3 vertexPos;
in vec4 vertexColor;

out vec4 outColor;

uniform vec3 cameraPos;

vec3 ambientLighting = 0.1*vec3(1.0, 0.8, 0.5);
vec3 surfaceColor = vec3(0.8, 0.8, 0.8);

vec3 lightPos = vec3(0,0,0);
vec3 lightColor = 20*vec3(1.0, 0.8, 0.0);

void main() {
	vec3 lAmbient = surfaceColor*ambientLighting;
	
	vec3 lPoint = lightColor / pow(distance(vertexPos, lightPos), 2);
	
	vec3 color = lAmbient;
	// Apply light only if the face is facing the light source
	if(dot(vertexNormal, vertexPos) < 0.0){
		color += lPoint;
	}
	
	outColor = vec4(color.x,
    				color.y,
    				color.z,
    				1);
}