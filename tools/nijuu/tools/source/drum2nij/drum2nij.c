#include <stdio.h>
#include <stdlib.h>

#define DRUM_SIZE 144
#define FRAME_SIZE 9
#define NUMBER_OF_FRAMES 8

int main (int argc, const char * argv[]) {
	FILE *inputFile;
	const char *inputFileName;
	long fileSize;
	char * buffer;
	size_t result;
	
	int i = 0;
	int a = 0;
	int drum;
	int frame;
	int doneAnything = 0;
	unsigned char drumFrame[FRAME_SIZE];
	
	if (argc>1)
	{
		inputFileName=argv[1];
	} else
	{
		fputs("ERROR - No input file.\n",stderr);
		exit(1);
	}
	//printf("File to open: %s\n",inputFileName);
	inputFile = fopen (inputFileName, "rb");
	if (!inputFile) {fputs("ERROR - Input file error.\n",stderr); exit(1);}
	
	//get file size
	fseek (inputFile, 0, SEEK_END);
	fileSize = ftell (inputFile);
	rewind(inputFile);
	
	//allocate memory for whole file
	buffer = (char*) malloc (sizeof(char)*fileSize);
	if (buffer == NULL) {fputs("ERROR - Cannot allocate memory.\n",stderr); exit(1);}
	
	//copy file to buffer
	result = fread (buffer, 1, fileSize, inputFile);
	if (result != fileSize) {fputs ("ERROR - Read error.\n",stderr); exit(1);}
	
	fclose(inputFile);
	//printf("%ld\n",fileSize);
	printf("\r\n");
	
	//drumFrame = (unsigned char *)malloc(sizeof(unsigned char) * FRAME_SIZE);
	//printf("Size of drumFrame %d\n",sizeof(drumFrame));

	for (drum=0;drum<2;drum++)
	{
		frame=0;
		do
		{
			for (a = 0;a<(FRAME_SIZE);a++)
			{
				drumFrame[a]=buffer[i];
				i++;
			}
			
			a = 0;
			doneAnything=0;
			if (drumFrame[a]!=0xFF)
			{
				printf("\tDRUM_A $%02X,$%02X,$%02X\r\n", drumFrame[a],drumFrame[a+1],drumFrame[a+2]);
				doneAnything++;
			}
			a=a+3;
			
			if (drumFrame[a]!=0xFF)
			{
				printf("\tDRUM_B $%02X,$%02X,$%02X\r\n", drumFrame[a],drumFrame[a+1],drumFrame[a+2]);
				doneAnything++;
			}
			a=a+3;
			
			if (drumFrame[a]!=0xFF)
			{
				printf("\tDRUM_C $%02X\r\n", drumFrame[a]);
				doneAnything++;
			}
			a=a+1;
			
			if (drumFrame[a]!=0xFF)
			{
				printf("\tDRUM_D $%02X,$%02X\r\n", drumFrame[a],drumFrame[a+1]);
				doneAnything++;
			}
			a=a+2;
			if (doneAnything>0)
			{
				printf("\tDFE\r\n");
			}
			frame++;
		}
		while (frame < NUMBER_OF_FRAMES);
		printf("\tDE\r\n\r\n");
	}
	
	free (buffer);
	
    return 0;
}
