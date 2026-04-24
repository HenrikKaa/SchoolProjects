#version 460
#define M_PI 3.1415926535897932384626433832795

out vec4 outColor;

in vec3 vertexPos;
in vec3 textCoord;
in vec3 vertexNormal;
in vec4 vertexColor;
in vec4 color;

uniform vec3 cameraPos;
uniform float uTime;

uniform sampler2D albedo_texture;
uniform sampler2D roughness_texture;
uniform sampler2D normal_texture;



// Light
vec3 light_dir = normalize(vec3(0.5, -0.75, 0.5));

// h - half vector
// v - view vector
// l - light direction vector
vec3 PBS();
float fresnel(vec3 h, vec3 l);
float jsm(vec3 l, vec3 v, vec3 h);
float ggxd(vec3 h);

// Helper
vec3 normal(vec2 uv);

void main() {
   outColor = vec4(PBS(), 1.0);
}

vec3 normal(vec2 uv){
	vec3 normal;
	
	normal = texture(normal_texture, uv).xyz;
	
	return normal;
}

vec3 PBS(){
	vec3 out_color;
	
	vec3 view_v = normalize(cameraPos-vertexPos);
	vec3 half_v = (light_dir+view_v)/length(light_dir+view_v);
	
	float fres = fresnel(half_v, light_dir);
	float shadow_mask = jsm(light_dir, view_v, half_v);
	float norm_distr = ggxd(half_v);
	
	float lcl = clamp(dot(normalize(vertexNormal), light_dir), 0, 1);
	
	float brdf_spec = fres * shadow_mask * norm_distr * lcl;
	
	vec2 uv = 2*vec2(
					textCoord.x - uTime * 0.01,
					textCoord.y - uTime * 0.005
					);
	vec3 albedo = texture(albedo_texture, uv).rgb;
	albedo = pow(albedo, vec3(2.2));
	vec3 brdf_diff = (1-fres) * albedo/M_PI * lcl;
	
	out_color = brdf_diff;
	out_color = pow(out_color, vec3(1/2.2));
	
	return out_color;
}

float fresnel(vec3 h, vec3 l){
	float F0 = 0.04;
	float value = F0 + (1-F0)*pow(1-clamp(dot(h,l),0,1), 5);
	
	return value;
}

float jsm(vec3 l, vec3 v, vec3 h){
	float value;
	
	float roughness = texture(albedo_texture, vertexPos.xy).x;
	float a2 = pow(roughness, 4);	// roughness
	float m_i = clamp(dot(normalize(vertexNormal), l), 0, 1);
	float m_o = clamp(dot(normalize(vertexNormal), v), 0, 1);
	
	value = 0.5/(
					m_o * sqrt(a2 + m_i*(m_i - a2*m_i)) +
					m_i * sqrt(a2 + m_o*(m_o - a2*m_o))
				);
	
	return value;
}

float ggxd(vec3 h){
	float value;
	
	float roughness = 0.1;
	float a2 = pow(roughness, 4);
	value = a2/(M_PI * pow(
						1 +
							pow(dot(normalize(vertexNormal), h), 2) *
							(a2 - 1)
						, 2)	// pow exponent
				);
	
	return value;
}