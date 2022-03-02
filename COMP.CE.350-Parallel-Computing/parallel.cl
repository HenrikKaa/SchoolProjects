typedef struct
{
	float x;
	float y;
} floatvector;
typedef struct
{
	float red;
	float green;
	float blue;
} color;
typedef struct
{
	color identifier;
	floatvector position;
	floatvector velocity;
} satellite;

// Copied from C source to avoid excess arguments for constants
// REMEMBER TO CHANGE THESE IF YOU EDIT THE C CODE
#define WINDOW_HEIGHT 1024
#define WINDOW_WIDTH 1024
#define SATELLITE_COUNT 64
#define SATELLITE_RADIUS 3.16f



__kernel 
void parallelGraphicsEngineCL(__global color* pixels, 
                			  __global satellite* satellites) {
	const int index = get_global_id(0);
   	// Row wise ordering
   	floatvector pixel = {.x = index % WINDOW_WIDTH, .y = index / WINDOW_HEIGHT};
   	// This color is used for coloring the pixel
   	color renderColor = {.red = 0.f, .green = 0.f, .blue = 0.f};
   	// This is the compound color of all other satellites
   	color renderColorOffset = {.red = 0.f, .green = 0.f, .blue = 0.f};

	// Find closest satellite
   	float shortestDistance = INFINITY;
   	float weights = 0.f;
   	int hitsSatellite = 0;

   	// First Graphics satellite loop: Find the closest satellite.
   	for (int j = 0; j < SATELLITE_COUNT; ++j)
   	{
    	floatvector difference = {.x = pixel.x - satellites[j].position.x,
                           .y = pixel.y - satellites[j].position.y};

      	float distanceSquared = difference.x * difference.x + difference.y * difference.y;

      	if (distanceSquared < SATELLITE_RADIUS * SATELLITE_RADIUS)
      	{
         	renderColor.red = 1.0f;
         	renderColor.green = 1.0f;
         	renderColor.blue = 1.0f;
         	hitsSatellite = 1;
         	break;
      	}
      	else
      	{
         	float weight = 1.0f / (distanceSquared * distanceSquared);
         	weights += weight;
         	if (distanceSquared < shortestDistance)
         	{
            	shortestDistance = distanceSquared;
            	renderColor = satellites[j].identifier;
         	}
      	}
   	}

   	// Second graphics loop: Calculate the color based on distance to every satellite.
   	if (!hitsSatellite)
   	{
    	for (int j = 0; j < SATELLITE_COUNT; ++j)
      	{
         	floatvector difference = {.x = pixel.x - satellites[j].position.x,
                              .y = pixel.y - satellites[j].position.y};

         	float dist2 = (difference.x * difference.x +
                     difference.y * difference.y);
         	float weight = 1.0f / (dist2 * dist2);

         	renderColorOffset.red += (satellites[j].identifier.red * weight);

         	renderColorOffset.green += (satellites[j].identifier.green * weight);

         	renderColorOffset.blue += (satellites[j].identifier.blue * weight);
      	}
      	renderColor.red += renderColorOffset.red / weights * 3.0f;
      	renderColor.green += renderColorOffset.green / weights * 3.0f;
      	renderColor.blue += renderColorOffset.blue / weights * 3.0f;
   	}
   	pixels[index] = renderColor;
}

