#version 330

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

void main()
{
	// Checkerboard pattern
	int gridSize = 32;
    int x = (int(gl_FragCoord.x) / gridSize) % 2;
	int y = (int(gl_FragCoord.y) / gridSize) % 2;
	float bw = (x^y);
	
    vec3 color = vec3(bw+sin(uTime),
    				  bw+sin(gl_FragCoord.x/uTime),
    				  bw+sin(gl_FragCoord.y/uTime));
    				  
    // Circle
    float circleRadius = 100*sin(uTime) + 150;
    vec2 circlePos = vec2(uResolution.x/2 * (1 + sin(uTime)/2),
    					  uResolution.y/2 * (1 + cos(2.3*uTime)/2));
   	vec3 circleColor = vec3(sin(1.3*uTime), sin(1.7*uTime), sin(1.9*uTime));
    if (length(gl_FragCoord.xy - circlePos) < circleRadius){
    	color = circleColor;
    }
    outColor = vec4(color, 1.0);
}