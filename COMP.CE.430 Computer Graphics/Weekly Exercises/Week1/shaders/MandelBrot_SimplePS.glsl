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

void main()
{
	vec2 center = vec2(2, 2);
    vec2 c = vec2((float(gl_FragCoord.x)/uResolution.x) * 2*center.x - center.x,
    			  (float(gl_FragCoord.y)/uResolution.y) * 2*center.y - center.y)/uTime;
    
    vec3 color = vec3(0, 0, 0);
    vec2 z = vec2(0,0);
    
    int LIMIT = 50;				
    for(int i=0;i<LIMIT; i++){
    	z = mult(z, z) + c;
    	
    	if(length(z)>2){
    		color = vec3(1.0, i, i)/LIMIT;
    		break;
    	}
    }
    
    outColor = vec4(color, 1.0);
}