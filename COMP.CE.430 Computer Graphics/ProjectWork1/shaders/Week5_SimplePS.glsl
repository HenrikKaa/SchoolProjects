#version 460
#define M_PI 3.1415926535897932384626433832795

in vec3 vertexNormal;
in vec3 vertexPos;
in vec4 vertexColor;

out vec4 outColor;

uniform vec3 cameraPos;

// Lighting
vec4 lighting();
vec3 ambientLighting = 0.1*vec3(1.0, 0.5, 0.2);
vec3 surfaceColor = vec3(0.8, 0.8, 0.8);

vec3 diffuseRefl = 0.5*vec3(1, 1, 1);

vec3 specularRefl = normalize(vec3(1, 1, 1));
float specularAlpha = 100;

vec3 lightColor = 2.0*normalize(vec3(1.0, 0.5, 0.5));
vec3 lightDir = normalize(vec3(0.25, 0.75, 0.75));

// Fog
vec4 fog(vec4 incolor);
vec4 fogHeight(vec4 incolor);
vec4 fogColor = 0.1*vec4(1.0, 1.0, 1.0, 1);
float extCoeff = 0.1;

// Post
vec4 gammaCorrection(vec4 incolor);
float gamma = 1/2.2;

// Spotlight
vec4 spotlight(vec4 incolor);
vec3 spotlightPos = vec3(-10.0, 5.0, 0.0);
vec3 spotlightDir = normalize(vec3(1.0, -0.5, -0.2));
vec3 spotlightColor = 50*vec3(0.5, 1.0, 0.5);
float angleInner = M_PI/16.0;
float angleOuter = M_PI/8.0;

// Linelight
vec4 linelight(vec4 incolor);
vec3 lineLightPosA = vec3(-2.0, 0.0, 5.0);
vec3 lineLightPosB = vec3(10.0, 0.0, 15.0);
vec3 lineLightColor = vec3(0.5, 0.1, 1.0);

void main() {
	vec4 color = lighting();
	color = fog(color);
	color = gammaCorrection(color);
	color = spotlight(color);
	color = linelight(color);
	
	outColor = color;
}

vec4 spotlight(vec4 incolor){
	vec3 color = incolor.xyz;
	
	float d = distance(vertexPos, spotlightPos);
	
	vec3 light_dir = normalize(vertexPos-spotlightPos);
	float s = dot(spotlightDir, light_dir);
	float t = (s-cos(angleOuter)) / (cos(angleInner)-cos(angleOuter));
	t = clamp(t, 0, 1);

	color += t*t*spotlightColor/(d*d);
	
	return vec4(color, 1);
}

vec4 linelight(vec4 incolor){
	vec3 color = incolor.xyz;

	vec3 a = lineLightPosA;
	vec3 b = lineLightPosB;
	vec3 p = vertexPos;
	float t = (dot(b-a, p-a)) /
			  (dot(b-a, b-a));
	t = clamp(t, 0, 1);

	vec3 closest_point = mix(a, b, t);
	float d = distance(vertexPos, closest_point);
	
	color += lineLightColor/(d*d);

	return vec4(color, 1);
}

vec4 lighting(){
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
    return vec4(color.x,
    				color.y,
    				color.z,
    				1);
}

vec4 fog(vec4 incolor){
	float d = distance(cameraPos, vertexPos);
	float f = exp(-extCoeff*d);
	
	// Height variation
	float a = 0.1;
	float b = 0.2;
	vec3 rayDir = normalize(vertexPos-cameraPos);
	float fogAmount = (a/b) * exp(-cameraPos.y*b) * (1.0-exp(-d*rayDir.y*b)) / rayDir.y;
	fogAmount = clamp(fogAmount, 0, 1);
	f = 1-fogAmount;
	
	vec4 color = incolor*f + fogColor*(1-f);
	
	return color;
}

vec4 gammaCorrection(vec4 incolor){
	vec4 color = incolor;
	color.x = pow(color.x, gamma);
	color.y = pow(color.y, gamma);
	color.z = pow(color.z, gamma);
	
	return color;
}