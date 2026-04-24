#version 330

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

void main()
{
    // Checkerboard pattern
	int gridSize = 32;

    // This is just LSD
    int x = (int(gl_FragCoord.x-20*sin(gl_FragCoord.y*uTime/1000)) / gridSize) % 2;
	int y = (int(gl_FragCoord.y) / gridSize) % 2;

    // Uncomment for slightly more normal
    /*x = (int(gl_FragCoord.x) / gridSize) % 2;
	y = (int(gl_FragCoord.y) / gridSize) % 2;*/
	float bw = (x^y);
	
    float offset = uTime+10;
    vec3 color = vec3(bw+sin(offset),
    				  bw+sin(gl_FragCoord.x/offset),
    				  bw+sin(gl_FragCoord.y/offset));
    				  
    // Circle
    float circleRadius = 100*sin(uTime) + 150;
    vec2 circlePos = vec2(uResolution.x/2 * (1 + sin(uTime)/2),
    					  uResolution.y/2 * (1 + cos(2.3*uTime)/2));
    float distance = length(gl_FragCoord.xy - circlePos);
    if (distance < circleRadius){
    	color = vec3(1-color.x, 1-color.y, 1-color.z);
    }

    outColor = vec4(color, 1.0);
}