#ifdef _WIN32
#include <windows.h>
#endif
#include <stdio.h> // printf
#include <math.h>  // INFINITY
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Window handling includes
#ifndef __APPLE__
#include <GL/gl.h>
#include <GL/glut.h>
#else
#include <OpenGL/gl.h>
#include <GLUT/glut.h>
#endif

// OpenCL includes
#define CL_TARGET_OPENCL_VERSION 200
#include <CL/cl.h>

// These are used to decide the window size
#define WINDOW_HEIGHT 1024
#define WINDOW_WIDTH 1024

// The number of satellites can be changed to see how it affects performance.
// Benchmarks must be run with the original number of satellites
#define SATELLITE_COUNT 64

// These are used to control the satellite movement
#define SATELLITE_RADIUS 3.16f
#define MAX_VELOCITY 0.1f
#define GRAVITY 1.0f
#define DELTATIME 32
#define PHYSICSUPDATESPERFRAME 100000

// Some helpers to window size variables
#define SIZE WINDOW_WIDTH *WINDOW_HEIGHT
#define HORIZONTAL_CENTER (WINDOW_WIDTH / 2)
#define VERTICAL_CENTER (WINDOW_HEIGHT / 2)

// Is used to find out frame times
int previousFrameTimeSinceStart = 0;
int previousFinishTime = 0;
unsigned int frameNumber = 0;
unsigned int seed = 0;

// Stores 2D data like the coordinates
typedef struct
{
	float x;
	float y;
} floatvector;

// Stores 2D data like the coordinates
typedef struct
{
	double x;
	double y;
} doublevector;

// Stores rendered colors. Each float may vary from 0.0f ... 1.0f
typedef struct
{
	float red;
	float green;
	float blue;
} color;

// Stores the satellite data, which fly around black hole in the space
typedef struct
{
	color identifier;
	floatvector position;
	floatvector velocity;
} satellite;

// Pixel buffer which is rendered to the screen
color *pixels;

// Pixel buffer which is used for error checking
color *correctPixels;

// Buffer for all satellites in the space
satellite *satellites;
satellite *backupSatelites;

// ## You may add your own variables here ##
// OpenCL stuff
#define SOURCEPATH "./parallel.cl"
cl_int status;
cl_kernel kernel;
cl_program program;
cl_command_queue cmdQueue;
cl_context context;
cl_platform_id* platforms;
cl_device_id* devices;
// Dta buffers
cl_mem bufPixels;
cl_mem bufSatellites;
// Source code
char* programSource;
// Work sizes
#define WORK_GROUP_SIZE 64
size_t globalWorkSize;
size_t workGroupSize;

// This function reads in a text file and stores it as a char pointer
void readSource(char* kernelPath) {
   	cl_int status;
   	FILE *fp;
   	long int size;

   	printf("Program file is: %s\n", kernelPath);

   	fp = fopen(kernelPath, "rb");
   	if(!fp) {
	  	printf("Could not open kernel file\n");
	  	exit(-1);
   	}
   	status = fseek(fp, 0, SEEK_END);
   	if(status != 0) {
	  	printf("Error seeking to end of file\n");
	  	exit(-1);
   	}
   	size = ftell(fp);
   	if(size < 0) {
	  	printf("Error getting file position\n");
	  	exit(-1);
   	}

   	rewind(fp);

   	programSource = (char *)malloc(size + 1);

   	int i;
   	for (i = 0; i < size+1; i++) {
		programSource[i]='\0';
   	}

   	if(programSource == NULL) {
	  	printf("Error allocating space for the kernel source\n");
	  	exit(-1);
   	}

   	fread(programSource, 1, size, fp);
	programSource[size] = '\0';
}

// For printing CL command status
// Copied from examples
void chk(cl_int status, const char* cmd) {

   if(status != CL_SUCCESS) {
		printf("%s failed (%d)\n", cmd, status);

		// Print out the error log
		char *buff_erro;
		cl_int errcode;
		size_t build_log_len;
		errcode = clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, 0, NULL, &build_log_len);
		if (errcode) {
			printf("clGetProgramBuildInfo failed at line %d\n", __LINE__);
			exit(-1);
		}

		buff_erro = malloc(build_log_len);
		if (!buff_erro) {
			printf("malloc failed at line %d\n", __LINE__);
			exit(-2);
		}

		errcode = clGetProgramBuildInfo(program, devices[0], CL_PROGRAM_BUILD_LOG, build_log_len, buff_erro, NULL);
		if (errcode) {
			printf("clGetProgramBuildInfo failed at line %d\n", __LINE__);
			exit(-3);
		}

		fprintf(stderr,"Build log: \n%s\n", buff_erro); //Be careful with  the fprint
		free(buff_erro);
		fprintf(stderr,"clBuildProgram failed\n");
	  	exit(-1);
   } else {
	  printf("%s successful (%d)\n", cmd, status);
   }
}

// ## You may add your own initialization routines here ##
void init()
{    
	// Retrieve the number of platforms
	cl_uint numPlatforms = 0;
	status = clGetPlatformIDs(0, NULL, &numPlatforms);
	chk(status, "clGetPlatformIDs");
 
	// Allocate enough space for each platform
	platforms = NULL;
	platforms = (cl_platform_id*)malloc(
		numPlatforms*sizeof(cl_platform_id));
 
	// Fill in the platforms
	status = clGetPlatformIDs(numPlatforms, platforms, NULL);
	chk(status, "clGetPlatformIDs");

	// Retrieve the number of devices
	cl_uint numDevices = 0;
	status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, 0, 
		NULL, &numDevices);
	chk(status, "clGetDeviceIDs");

	// Allocate enough space for each device
	devices = (cl_device_id*)malloc(
		numDevices*sizeof(cl_device_id));

	// Fill in the devices 
	status = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL,        
		numDevices, devices, NULL);
	chk(status, "clGetDeviceIDs");

	// Create a context and associate it with the devices
	context = clCreateContext(NULL, numDevices, devices, NULL, 
		NULL, &status);
	chk(status, "clCreateContext");

	// Create a command queue and associate it with the device 
	cmdQueue = clCreateCommandQueueWithProperties(context, devices[0], 0, 
		&status);
	chk(status, "clCreateCommandQueueWithProperties"); 

	///// BUFFERS /////
	// Buffer for pixels
	size_t pixelbufsize = sizeof(color)*SIZE;
	bufPixels = clCreateBuffer(context, CL_MEM_WRITE_ONLY, pixelbufsize,                       
	   NULL, &status);
	// Buffer for satellite positions
	size_t satellitebufsize = sizeof(satellite) * SATELLITE_COUNT;
	bufSatellites = clCreateBuffer(context, CL_MEM_READ_ONLY, satellitebufsize,                       
	   NULL, &status);
	chk(status, "clCreateBuffer"); 

	// Create program from source code
	readSource(SOURCEPATH);
	program = clCreateProgramWithSource(context, 1, 
		(const char**)&programSource, NULL, &status);
	chk(status, "clCreateProgramWithSource");

	// Build program/kernel
	status = clBuildProgram(program, numDevices, devices, 
		NULL, NULL, NULL);
	chk(status, "clBuildProgram");

	// Create kernel
	kernel = clCreateKernel(program, "parallelGraphicsEngineCL", &status);
	chk(status, "clCreateKernel"); 

	// Associate the input and output buffers with the kernel 
	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufPixels);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufSatellites);
	chk(status, "clSetKernelArg");

	globalWorkSize = WINDOW_HEIGHT*WINDOW_WIDTH;
	workGroupSize = WORK_GROUP_SIZE;
}

// ## You are asked to make this code parallel ##
// Physics engine loop. (This is called once a frame before graphics engine)
// Moves the satellites based on gravity
// This is done multiple times in a frame because the Euler integration
// is not accurate enough to be done only once
void parallelPhysicsEngine()
{
	// double precision required for accumulation inside this routine,
	// but float storage is ok outside these loops.
	doublevector tmpPosition[SATELLITE_COUNT];
	doublevector tmpVelocity[SATELLITE_COUNT];

	// Vectorized by gcc
	for (int i = 0; i < SATELLITE_COUNT; ++i)
	{
		tmpPosition[i].x = satellites[i].position.x;
		tmpPosition[i].y = satellites[i].position.y;
		tmpVelocity[i].x = satellites[i].velocity.x;
		tmpVelocity[i].y = satellites[i].velocity.y;
	}

	// Physics iteration loop
	// Cannot be vectorized or parallelized
	for (int physicsUpdateIndex = 0;
		 physicsUpdateIndex < PHYSICSUPDATESPERFRAME;
		 ++physicsUpdateIndex)
	{

		// Physics satellite loop
		// gcc does vectorize but parallelizing is not worth it
		for (int i = 0; i < SATELLITE_COUNT; ++i)
		{

			// Distance to the blackhole (bit ugly code because C-struct cannot have member functions)
			doublevector positionToBlackHole = {
				.x = tmpPosition[i].x - HORIZONTAL_CENTER,
				.y = tmpPosition[i].y - VERTICAL_CENTER};
			double distToBlackHoleSquared =
				positionToBlackHole.x * positionToBlackHole.x +
				positionToBlackHole.y * positionToBlackHole.y;

			double distToBlackHole = sqrt(distToBlackHoleSquared);
			// Gravity force
			doublevector normalizedDirection = {
				.x = positionToBlackHole.x / distToBlackHole,
				.y = positionToBlackHole.y / distToBlackHole};
			double accumulation = GRAVITY / distToBlackHoleSquared;

			// Delta time is used to make velocity same despite different FPS
			// Update velocity based on force
			tmpVelocity[i].x -= accumulation * normalizedDirection.x *
								DELTATIME / PHYSICSUPDATESPERFRAME;
			tmpVelocity[i].y -= accumulation * normalizedDirection.y *
								DELTATIME / PHYSICSUPDATESPERFRAME;

			// Update position based on velocity
			tmpPosition[i].x +=
				tmpVelocity[i].x * DELTATIME / PHYSICSUPDATESPERFRAME;
			tmpPosition[i].y +=
				tmpVelocity[i].y * DELTATIME / PHYSICSUPDATESPERFRAME;
		}
	}

	// double precision required for accumulation inside this routine,
	// but float storage is ok outside these loops.
	// copy back the float storage.
	// Vectorized by gcc
	for (int i = 0; i < SATELLITE_COUNT; ++i)
	{
		satellites[i].position.x = tmpPosition[i].x;
		satellites[i].position.y = tmpPosition[i].y;
		satellites[i].velocity.x = tmpVelocity[i].x;
		satellites[i].velocity.y = tmpVelocity[i].y;
	}
}

// ## You are asked to make this code parallel ##
// Rendering loop (This is called once a frame after physics engine)
// Decides the color for each pixel.
void parallelGraphicsEngine()
{
	// Print statuses only once
	static int first = 1;

	// All these are in blocking mode but the next physics frame could
	// be calculated simultaneously.
	// Write satellite positions to device
	status = clEnqueueWriteBuffer(cmdQueue, bufSatellites, CL_TRUE, 
		0, sizeof(satellite)*SATELLITE_COUNT, satellites, 0, NULL, NULL);
	if(first) chk(status, "clEnqueueWriteBuffer");
	
	// Execute kernel
	status = clEnqueueNDRangeKernel(cmdQueue, kernel, 1, NULL, 
		&globalWorkSize, &workGroupSize, 0, NULL, NULL);
	if(first) chk(status, "clEnqueueNDRangeKernel");

	// Read pixel output buffer
	status = clEnqueueReadBuffer(cmdQueue, bufPixels, CL_TRUE, 0, 
		sizeof(color)*SIZE, pixels, 0, NULL, NULL);
	if(first) chk(status, "clEnqueueReadBuffer");

	first = 0;
}

// ## You may add your own destrcution routines here ##
void destroy()
{
	// Free OpenCL resources
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseCommandQueue(cmdQueue);
	clReleaseMemObject(bufPixels);
	clReleaseMemObject(bufSatellites);
	clReleaseContext(context);

	// Free host resources
	free(platforms);
	free(devices);
}

////////////////////////////////////////////////
// ¤¤ TO NOT EDIT ANYTHING AFTER THIS LINE ¤¤ //
////////////////////////////////////////////////

// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
// Sequential rendering loop used for finding errors
void sequentialGraphicsEngine()
{

	// Graphics pixel loop
	for (int i = 0; i < SIZE; ++i)
	{

		// Row wise ordering
		floatvector pixel = {.x = i % WINDOW_WIDTH, .y = i / WINDOW_WIDTH};

		// This color is used for coloring the pixel
		color renderColor = {.red = 0.f, .green = 0.f, .blue = 0.f};

		// Find closest satellite
		float shortestDistance = INFINITY;

		float weights = 0.f;
		int hitsSatellite = 0;

		// First Graphics satellite loop: Find the closest satellite.
		for (int j = 0; j < SATELLITE_COUNT; ++j)
		{
			floatvector difference = {.x = pixel.x - satellites[j].position.x,
									  .y = pixel.y - satellites[j].position.y};
			float distance = sqrt(difference.x * difference.x +
								  difference.y * difference.y);

			if (distance < SATELLITE_RADIUS)
			{
				renderColor.red = 1.0f;
				renderColor.green = 1.0f;
				renderColor.blue = 1.0f;
				hitsSatellite = 1;
				break;
			}
			else
			{
				float weight = 1.0f / (distance * distance * distance * distance);
				weights += weight;
				if (distance < shortestDistance)
				{
					shortestDistance = distance;
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

				renderColor.red += (satellites[j].identifier.red *
									weight / weights) *
								   3.0f;

				renderColor.green += (satellites[j].identifier.green *
									  weight / weights) *
									 3.0f;

				renderColor.blue += (satellites[j].identifier.blue *
									 weight / weights) *
									3.0f;
			}
		}
		correctPixels[i] = renderColor;
	}
}

void sequentialPhysicsEngine(satellite *s)
{
	// double precision required for accumulation inside this routine,
	// but float storage is ok outside these loops.
	doublevector tmpPosition[SATELLITE_COUNT];
	doublevector tmpVelocity[SATELLITE_COUNT];

	for (int i = 0; i < SATELLITE_COUNT; ++i)
	{
		tmpPosition[i].x = s[i].position.x;
		tmpPosition[i].y = s[i].position.y;
		tmpVelocity[i].x = s[i].velocity.x;
		tmpVelocity[i].y = s[i].velocity.y;
	}

	// Physics iteration loop
	for (int physicsUpdateIndex = 0;
		 physicsUpdateIndex < PHYSICSUPDATESPERFRAME;
		 ++physicsUpdateIndex)
	{

		// Physics satellite loop
		for (int i = 0; i < SATELLITE_COUNT; ++i)
		{

			// Distance to the blackhole
			// (bit ugly code because C-struct cannot have member functions)
			doublevector positionToBlackHole = {.x = tmpPosition[i].x -
													 HORIZONTAL_CENTER,
												.y = tmpPosition[i].y - VERTICAL_CENTER};
			double distToBlackHoleSquared =
				positionToBlackHole.x * positionToBlackHole.x +
				positionToBlackHole.y * positionToBlackHole.y;
			double distToBlackHole = sqrt(distToBlackHoleSquared);
			// Gravity force
			doublevector normalizedDirection = {
				.x = positionToBlackHole.x / distToBlackHole,
				.y = positionToBlackHole.y / distToBlackHole};
			double accumulation = GRAVITY / distToBlackHoleSquared;

			// Delta time is used to make velocity same despite different FPS
			// Update velocity based on force
			tmpVelocity[i].x -= accumulation * normalizedDirection.x *
								DELTATIME / PHYSICSUPDATESPERFRAME;
			tmpVelocity[i].y -= accumulation * normalizedDirection.y *
								DELTATIME / PHYSICSUPDATESPERFRAME;

			// Update position based on velocity
			tmpPosition[i].x +=
				tmpVelocity[i].x * DELTATIME / PHYSICSUPDATESPERFRAME;
			tmpPosition[i].y +=
				tmpVelocity[i].y * DELTATIME / PHYSICSUPDATESPERFRAME;
		}
	}

	// double precision required for accumulation inside this routine,
	// but float storage is ok outside these loops.
	// copy back the float storage.
	for (int i = 0; i < SATELLITE_COUNT; ++i)
	{
		s[i].position.x = tmpPosition[i].x;
		s[i].position.y = tmpPosition[i].y;
		s[i].velocity.x = tmpVelocity[i].x;
		s[i].velocity.y = tmpVelocity[i].y;
	}
}

// Just some value that barely passes for OpenCL example program
#define ALLOWED_FP_ERROR 0.08
// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
void errorCheck()
{
	for (unsigned int i = 0; i < SIZE; ++i)
	{
		if (fabs(correctPixels[i].red - pixels[i].red) > ALLOWED_FP_ERROR ||
			fabs(correctPixels[i].green - pixels[i].green) > ALLOWED_FP_ERROR ||
			fabs(correctPixels[i].blue - pixels[i].blue) > ALLOWED_FP_ERROR)
		{
			printf("Buggy pixel at (x=%i, y=%i). Press enter to continue.\n", i % WINDOW_WIDTH, i / WINDOW_WIDTH);
			getchar();
			return;
		}
	}
	printf("Error check passed!\n");
}

// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
void compute(void)
{
	int timeSinceStart = glutGet(GLUT_ELAPSED_TIME);
	previousFrameTimeSinceStart = timeSinceStart;

	// Error check during first frames
	if (frameNumber < 2)
	{
		memcpy(backupSatelites, satellites, sizeof(satellite) * SATELLITE_COUNT);
		sequentialPhysicsEngine(backupSatelites);
	}
	parallelPhysicsEngine();
	if (frameNumber < 2)
	{
		for (int i = 0; i < SATELLITE_COUNT; i++)
		{
			if (memcmp(&satellites[i], &backupSatelites[i], sizeof(satellite)))
			{
				printf("Incorrect satellite data of satellite: %d\n", i);
				getchar();
			}
		}
	}

	int satelliteMovementMoment = glutGet(GLUT_ELAPSED_TIME);
	int satelliteMovementTime = satelliteMovementMoment - timeSinceStart;

	// Decides the colors for the pixels
	parallelGraphicsEngine();

	int pixelColoringMoment = glutGet(GLUT_ELAPSED_TIME);
	int pixelColoringTime = pixelColoringMoment - satelliteMovementMoment;

	// Sequential code is used to check possible errors in the parallel version
	if (frameNumber < 2)
	{
		sequentialGraphicsEngine();
		errorCheck();
	}

	int finishTime = glutGet(GLUT_ELAPSED_TIME);
	// Print timings
	int totalTime = finishTime - previousFinishTime;
	previousFinishTime = finishTime;

	printf("Total frametime: %ims, satellite moving: %ims, space coloring: %ims.\n",
		   totalTime, satelliteMovementTime, pixelColoringTime);

	// Render the frame
	glutPostRedisplay();
}

// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
// Probably not the best random number generator
float randomNumber(float min, float max)
{
	return (rand() * (max - min) / RAND_MAX) + min;
}

// DO NOT EDIT THIS FUNCTION
void fixedInit(unsigned int seed)
{

	if (seed != 0)
	{
		srand(seed);
	}

	// Init pixel buffer which is rendered to the widow
	pixels = (color *)malloc(sizeof(color) * SIZE);

	// Init pixel buffer which is used for error checking
	correctPixels = (color *)malloc(sizeof(color) * SIZE);

	backupSatelites = (satellite *)malloc(sizeof(satellite) * SATELLITE_COUNT);

	// Init satellites buffer which are moving in the space
	satellites = (satellite *)malloc(sizeof(satellite) * SATELLITE_COUNT);

	// Create random satellites
	for (int i = 0; i < SATELLITE_COUNT; ++i)
	{

		// Random reddish color
		color id = {.red = randomNumber(0.f, 0.15f) + 0.1f,
					.green = randomNumber(0.f, 0.14f) + 0.0f,
					.blue = randomNumber(0.f, 0.16f) + 0.0f};

		// Random position with margins to borders
		floatvector initialPosition = {.x = HORIZONTAL_CENTER - randomNumber(50, 320),
									   .y = VERTICAL_CENTER - randomNumber(50, 320)};
		initialPosition.x = (i / 2 % 2 == 0) ? initialPosition.x : WINDOW_WIDTH - initialPosition.x;
		initialPosition.y = (i < SATELLITE_COUNT / 2) ? initialPosition.y : WINDOW_HEIGHT - initialPosition.y;

		// Randomize velocity tangential to the balck hole
		floatvector positionToBlackHole = {.x = initialPosition.x - HORIZONTAL_CENTER,
										   .y = initialPosition.y - VERTICAL_CENTER};
		float distance = (0.06 + randomNumber(-0.01f, 0.01f)) /
						 sqrt(positionToBlackHole.x * positionToBlackHole.x +
							  positionToBlackHole.y * positionToBlackHole.y);
		floatvector initialVelocity = {.x = distance * -positionToBlackHole.y,
									   .y = distance * positionToBlackHole.x};

		// Every other orbits clockwise
		if (i % 2 == 0)
		{
			initialVelocity.x = -initialVelocity.x;
			initialVelocity.y = -initialVelocity.y;
		}

		satellite tmpSatelite = {.identifier = id, .position = initialPosition, .velocity = initialVelocity};
		satellites[i] = tmpSatelite;
	}
}

// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
void fixedDestroy(void)
{
	destroy();

	free(pixels);
	free(correctPixels);
	free(satellites);

	if (seed != 0)
	{
		printf("Used seed: %i\n", seed);
	}
}

// ¤¤ DO NOT EDIT THIS FUNCTION ¤¤
// Renders pixels-buffer to the window
void render(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glDrawPixels(WINDOW_WIDTH, WINDOW_HEIGHT, GL_RGB, GL_FLOAT, pixels);
	glutSwapBuffers();
	frameNumber++;
}

// DO NOT EDIT THIS FUNCTION
// Inits glut and start mainloop
int main(int argc, char **argv)
{

	if (argc > 1)
	{
		seed = atoi(argv[1]);
		printf("Using seed: %i\n", seed);
	}

	// Init glut window
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT);
	glutCreateWindow("Parallelization excercise");
	glutDisplayFunc(render);
	atexit(fixedDestroy);
	previousFrameTimeSinceStart = glutGet(GLUT_ELAPSED_TIME);
	previousFinishTime = glutGet(GLUT_ELAPSED_TIME);
	glEnable(GL_DEPTH_TEST);
	glClearColor(0.0, 0.0, 0.0, 1.0);
	fixedInit(seed);
	init();

	// compute-function is called when everythin from last frame is ready
	glutIdleFunc(compute);

	// Start main loop
	glutMainLoop();
}

