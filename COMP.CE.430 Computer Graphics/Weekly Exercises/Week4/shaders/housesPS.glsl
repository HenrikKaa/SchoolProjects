#version 460

in vec3 vertexNormal;
in vec3 vertexPos;
in vec4 vertexColor;

out vec4 outColor;

uniform vec3 cameraPos;

void lighting();

// Lighting
vec3 ambientLighting = 0.2*vec3(1.0, 0.8, 0.5);
vec3 surfaceColor = vec3(0.8, 0.8, 0.8);

vec3 diffuseRefl = 0.5*vec3(1, 1, 1);

vec3 specularRefl = vec3(1, 1, 1);
float specularAlpha = 100;

vec3 lightColor = 10.0*vec3(0.9, 0.9, 1.0);
vec3 lightDir = normalize(vec3(0.25, 0.75, 0.75));

void main() {
	lighting();
}

void lighting(){
	// Ambient
	vec3 lAmbient = surfaceColor*ambientLighting;
	
	// Diffuse
	vec3 lDiffuse = diffuseRefl*max(dot(vertexNormal, lightDir), 0)*lightColor;
	
	// Specular
	vec3 reflDir = reflect(-lightDir, vertexNormal);
	vec3 cameraDir = normalize(cameraPos - vertexPos);
	
	// Blinn-Phong model
	vec3 H = (lightDir+cameraDir)/length(lightDir+cameraDir);
	vec3 lSpecular = specularRefl * pow((dot(H, vertexNormal)), specularAlpha) * lightColor;
	//vec3 lSpecular = specularRefl * pow((dot(reflDir, cameraDir)), specularAlpha) * lightColor;
	lSpecular = max(vec3(0,0,0), lSpecular);
	
	// Out color
	vec3 color = lAmbient + lDiffuse + lSpecular;
    outColor = vec4(color.x,
    				color.y,
    				color.z,
    				1);
}