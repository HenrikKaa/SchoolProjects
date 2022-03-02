#!/bin/sh

valid_cmd=1

case $1 in
	"noop") 		gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm;;
	"mostop") 		gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2;;
	"mostopo3") 	gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O3;;
	"vec") 			gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec;;
	"mathrelax") 	gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math;;
	"ofast") 		gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -Ofast;;
	"avx")			gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx;;
	"avx2")			gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx2;;
	"avx512")		gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx512f;;
	"sse4")			gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -msse4;;

	"additional") 	gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec-all -ffast-math -fsingle-precision-constant -fsched2-use-traces -fcx-limited-range;;
	"arcs") 	    gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx2 -fsingle-precision-constant -fsched2-use-traces -fprofile-arcs;;
	"recomp") 	    gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx2 -fsingle-precision-constant -fsched2-use-traces -fbranch-probabilities -fvpt;;
	"arcsomp") 	    gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx2 -fsingle-precision-constant -fsched2-use-traces -fprofile-arcs -fopenmp;;
	"recompomp") 	gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -mavx2 -fsingle-precision-constant -fsched2-use-traces -fbranch-probabilities -fvpt -fopenmp;;

	"openmp") 		gcc -o parallel parallel.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -fopenmp;;
	"opencl") 		gcc -o parallel parallel_cl.c -std=c99 -lglut -lGL -lm -O2 -ftree-vectorize -fopt-info-vec -ffast-math -fopenmp -I /opt/AMDAPP/include -L /opt/AMDAPP/lib/x86_64 -lOpenCL;;
    *) echo "No settings found";
		valid_cmd=0;;
esac

if [ $valid_cmd -eq 1 ]
then
	./parallel;
fi