#version 330

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

vec2 mult(vec2 a, vec2 b){
	return vec2(
				a.x*b.x - a.y*b.y,
				a.x*b.y + a.y*b.x
				);
}

// https://gist.github.com/983/e170a24ae8eba2cd174f
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec2 center = vec2(2, 2);
    vec2 c = vec2((float(gl_FragCoord.x)/uResolution.x) * 2*center.x - center.x,
    			  (float(gl_FragCoord.y)/uResolution.y) * 2*center.y - center.y);
    
    vec3 color = vec3(0, 0, 0);
    vec2 z = vec2(0,0);
    
    int LIMIT = 50;				
    for(int i=0;i<LIMIT; i++){
    	z = mult(z, z) + c;
    	
    	if(length(z)>2){
    		color = hsv2rgb(vec3(
								float(i) / float(LIMIT),
								1.0,
								1.0));
    		break;
    	}
    }
    
    outColor = vec4(color, 1.0);
}