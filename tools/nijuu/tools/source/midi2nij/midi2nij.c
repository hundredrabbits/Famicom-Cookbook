//
//MIDI2NIJ - convert single track MIDI file to Nijuu text/macros
//Written by Neil Baldwin June 2009
//
//Todo - more error checking
//Todo - test with more sequencers. "Logic" and "Reaper" tested so far.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "midifile.h"

/* MIDI status commands most significant bit is 1 */
#define NOTE_OFF			0x80
#define NOTE_ON				0x90
#define POLY_AFTERTOUCH		0xA0
#define CONTROL_CHANGE		0xB0
#define PROGRAM_CHANGE		0xC0
#define CHANNEL_AFTERTOUCH	0xD0
#define PITCH_WHEEL      	0xE0
#define SYS_EX				0xF0
#define SYS_EX_CONTINUE		0xF7
//#define DELAY_PACKET	 	(1111)

/* 7 bit controllers */
#define DAMPER_PEDAL		0x40
#define PORTAMENTO			0x41 	
#define SOSTENUTO			0x42
#define SOFT_PEDAL			0x43
#define GENERAL_4			0x44
#define	HOLD_2				0x45
#define	GENERAL_5			0x50
#define	GENERAL_6			0x51
#define GENERAL_7			0x52
#define GENERAL_8			0x53
#define TREMOLO_DEPTH		0x5C
#define CHORUS_DEPTH		0x5D
#define	DETUNE				0x5E
#define PHASER_DEPTH		0x5F

/* parameter values */
#define DATA_INC			0x60
#define DATA_DEC			0x61

/* parameter selection */
#define NON_REG_LSB			0x62
#define NON_REG_MSB			0x63
#define REG_LSB				0x64
#define REG_MSB				0x65

/* Standard MIDI Files meta event definitions */
#define	META_EVENT			0xFF
#define	SEQUENCE_NUMBER		0x00
#define	TEXT_EVENT			0x01
#define COPYRIGHT_NOTICE	0x02
#define SEQUENCE_NAME		0x03
#define INSTRUMENT_NAME		0x04
#define LYRIC				0x05
#define MARKER				0x06
#define	CUE_POINT			0x07
#define CHANNEL_PREFIX		0x20
#define	END_OF_TRACK		0x2F
#define	SET_TEMPO			0x51
#define	SMPTE_OFFSET		0x54
#define	TIME_SIGNATURE		0x58
#define	KEY_SIGNATURE		0x59
#define	SEQUENCER_SPECIFIC	0x7F

/* miscellaneous definitions */
#define MThd "MThd" //0x4d546864L
#define MTrk "MTrk" //0x4d54726bL

#define	MODE_NOTHING 0
#define MODE_NOTE 1
#define MODE_REST 2
#define MODE_END 3

//Header information
unsigned int MF_headerSize;
unsigned short MF_type;
unsigned short MF_numberOfTracks;
unsigned short MF_timeDivision;

//Variables
unsigned int bytesToRead;
unsigned int endOfTrack;
unsigned int bytesToRead = 0;
unsigned int currentDelta = 0;
unsigned char eventType;
int NOTE_MODE;
int firstNoteInSeq = 0;
int previousDelta = -1;
int thisDuration = 0;
int previousDuration = 0;
int previousNote = 0;
int thisVelocity = 100;
int previousVelocity = 0;
int lastD = 0;
int firstNoteOnLine = 0;
int newLine = 0;
int noteCount = 0;
int runningStatus = 0;
int OVERLAP_FLAG = 0;
int SCALE_WARNING = 0;

//Flags
int SMALLEST_NOTE = 8;
int PPQN_SCALE = 240;
int OUTPUT_VELOCITY = 0;
int NOTES_PER_LINE = 8;
int SHOW_MIDI_FILE_INFO =0;

//Functions
unsigned char readByte(FILE *file);
unsigned short read16bit(FILE *file);
unsigned int read32bit(FILE *file);
unsigned int readVarLenNum(FILE *file);
void readMT(char *strOut,FILE *file);
unsigned short readHeader(FILE *file);
void processTrack(FILE *file);
void channelMessage(unsigned char status, unsigned char c1, unsigned char c2);
void systemExclusive(unsigned char type);
void skipFile(FILE *file, int skip);
void processNoteOn(unsigned char status, unsigned char c1, unsigned char c2);
void processNoteOff(unsigned char status, unsigned char c1, unsigned char c2);
char * makeNote(unsigned char pitch);
void parseOption(const char *option);

FILE *inputFile;
char inputFileName [80];
char argoption[80];

void parseOption(const char *option)
{
	option+=2;
	strcpy(argoption,option);
}

int main (int argc, const char * argv[]) {
		
	//printf("Number of arguments: %d\n",argc);
	if (argc < 2)
	{
		printf("\nMIDI2NIJ V0.2\n\n");
		printf("Usage : MIDI2NIJ [-s] [-n] <input file>\n\n");
		printf("-i\t\tShow MIDI file information\n\n");
		printf("-s<value>\tSet PPQN scale. Default=240\n");
		printf("\n-n<value>\tSets the length of a 16th note in frames. Default=8\n");
		printf("\n-v<value>\tOutputs velocities, <value> is sensitivity. Default=0 (none)\n");
		printf("\n-p<value>\tMax notes/rests per text line. Default=8\n\n");
		exit(0);
	} else
	{
		//Parse all input parameters
		int i;
		for (i=1;i<argc;i++)
		{
			//if first char of argument = "-" then get parameter
			if ((argv[i][0]) == '-')
			{
				int p = argv[i][1];
				switch (p) {
					case 'v':
					case 'V':
						parseOption(argv[i]);
						OUTPUT_VELOCITY = atoi(argoption);
						break;
					case 'n':
					case 'N':
						parseOption(argv[i]);
						SMALLEST_NOTE = atoi(argoption);
						break;
					case 's':
					case 'S':
						parseOption(argv[i]);
						PPQN_SCALE = atoi(argoption);
						break;
					case 'i':
					case 'I':
						SHOW_MIDI_FILE_INFO=1;
						break;
					case 'p':
					case 'P':
						parseOption(argv[i]);
						NOTES_PER_LINE = atoi(argoption);
						break;
						
					default:
						break;
				}
						
			} else
			{
				//If first char not "-" then argument is input filename
				strcpy(inputFileName, argv[i]);
			}
		}
		
		
	}
		
	//Open the MIDI file
	inputFile = fopen(inputFileName,"rb");
	
	if (inputFile != NULL)
	{
		//readHeader returns 1 if "MThd" is first 4 bytes of file
		if (readHeader(inputFile))
		{
			if (MF_timeDivision!=960) SCALE_WARNING = 1;
			if (SHOW_MIDI_FILE_INFO)
			{
				printf("MIDI File\n");
				printf("Header length: %d\n", MF_headerSize);
				printf("MIDI File type: %d\n", MF_type);
				printf("Number of tracks: %d\n", MF_numberOfTracks);
				printf("Time Division: %d\n", MF_timeDivision);
			}
			//Process all the tracks
			//Should error trap if more than 1
			do
			{
				processTrack(inputFile);
				MF_numberOfTracks--;
			} while (MF_numberOfTracks>0);
			
			
			if (OVERLAP_FLAG)
			{
				if (runningStatus)
				{
					printf("Warning\n");
					printf("Some kind of note overlap occurred but MIDI file was using 'running status' so it's probably OK\n\n");
				} else
				{
					printf("Warning\n");
					printf("Some kind of note overlap occurred. This can sometimes happen if ");
					printf("notes are close together but check MIDI file for overlaps.\n\n");
				}
			}
			
			if (SCALE_WARNING)
			{
				printf("Warning\n");
				printf("Time division of file was %d but 960 was expected. You might need to ",MF_timeDivision);
				printf("alter the -Sn setting to get the correct note durations\n");
			}
			
			fclose(inputFile);
		} else
		{
			printf("Error. Not MIDI File\n");
			fclose(inputFile);
		}
		
	} else
	{
		printf("Error opeing input file!\n");
	}
	
    return 0;
}


//
//Process Track
//
void processTrack(FILE *file)
{
	//Number of bytes neeeded by message type
	int needed = 0;
	static int channelType [] = {
			0, 0, 0, 0, 0, 0, 0, 0,
			2, 2, 2, 2, 1, 1, 2, 0};
	
	char s[5];
	//Read (& skip) 'MTrk'
	readMT(s,file);
	bytesToRead = read32bit(file);

	firstNoteInSeq = 1;
	newLine = 1;
	NOTE_MODE = MODE_NOTHING;

	endOfTrack = 0;
	while (!endOfTrack)
	{
		unsigned char c;
		//Get delta time of next event
		currentDelta = readVarLenNum(file);
		//Get type of next event
		eventType = readByte(inputFile);
		//get number of extra data bytes required based on the command
		needed = channelType[(eventType >> 4) & 0x0F];
		
		//Channel Events 0x8n to 0xEn
		if (eventType < 0xF0)
		{
			if (eventType < 0x80)
			{
				//printf("Running Status\n");
				c = eventType;
				eventType = runningStatus;
				channelMessage(eventType, c, readByte(inputFile));
			} else
			{
				runningStatus = eventType;
				//Channel message. Get next data byte (all commands have at least one)
				c = readByte(inputFile);
				//process channel message but grab another data byte if required
				channelMessage(eventType, c, (needed>1) ? readByte(inputFile) : 0);
			}
			
		} else
		{
			//Sysex
			switch (eventType)
			{
				case META_EVENT:
					systemExclusive(readByte(inputFile));
					break;
				case SYS_EX:
					skipFile(inputFile, readVarLenNum(inputFile));
					break;
				case SYS_EX_CONTINUE:
					skipFile(inputFile, readVarLenNum(inputFile));
					break;
				default:
					printf("Oops! Something's not right...\n");
					exit (1);
					break;
			}
		}
	}
}


//
//Skip part of file
//
void skipFile(FILE *file, int skip)
{
	fseek(file, skip, SEEK_CUR);
}

//
//Process System Exclusive
//
void systemExclusive(unsigned char type)
{
	switch (type)
	{
		case SEQUENCE_NUMBER:
			//Get var number and move
			skipFile(inputFile, readVarLenNum(inputFile));
			break;
		case TEXT_EVENT:	/* Text event */
		case COPYRIGHT_NOTICE:	/* Copyright notice */
		case SEQUENCE_NAME:	/* Sequence/Track name */
		case INSTRUMENT_NAME:	/* Instrument name */
		case LYRIC:	/* Lyric */
		case MARKER:	/* Marker */
		case CUE_POINT:	/* Cue point */
		case 0x08:
		case 0x09:
		case 0x0a:
		case 0x0b:
		case 0x0c:
		case 0x0d:
		case 0x0e:
		case 0x0f:
			//Get var number and move
			skipFile(inputFile, readVarLenNum(inputFile));
			break;
		case END_OF_TRACK:	/* End of Track */
			skipFile(inputFile, readVarLenNum(inputFile));
			NOTE_MODE = MODE_END;
			processNoteOff(0x80,previousNote,0);
			printf("\n\tES\n\n");
			endOfTrack = 1;
			break;
		case SET_TEMPO:	/* Set tempo */
		case SMPTE_OFFSET:
		case TIME_SIGNATURE:
		case KEY_SIGNATURE:
		case SEQUENCER_SPECIFIC:
		default:
			//Get var number and move
			skipFile(inputFile, readVarLenNum(inputFile));
			break;
	}
}

//
//Process Note On/Off
//
/*
 There are 4 modes based on what is being pulled in from the track data.
 MODE_NOTHING = initial mode when starting new track
 MODE_REST = just processed a noteOff command
 MODE_NOTE = just processed a noteOn command
 MODE_END = end of current track
 
 This routine processes notes one-at-a-time to turn delta times into duration (D) commands
 If the duration of two consecutive notes is the same, no "D" command is output.
 
 If velocity (V) option is set, the velocity value of consecutive notes is compared and if
 the difference excedes the V option value, a "V" command is output.
 
 Rests (gaps between notes) are also output. If duration of rest is the same as last note
 duration, an inline rest is output "_". Otherwise a "RD" command is output along with a
 value for the length of the rest.
 
*/
void processNoteOn(unsigned char status, unsigned char c1, unsigned char c2)
{
	//printf("\nNOTE_ON %d %d %d\n",status,c1,c2);
	float d;
	int a,c;
	
	switch (NOTE_MODE) {
		case MODE_NOTHING:
			if (firstNoteInSeq == 1)
			{
				if (currentDelta > 0)
				{
					thisDuration = currentDelta;
					previousDelta = currentDelta;
					previousNote = c1;
					thisVelocity = c2 >> 3;
					d = (float)thisDuration;
					a = (int)((d * SMALLEST_NOTE)/(int)PPQN_SCALE);
					c = 0;
					if (a!=((d * SMALLEST_NOTE)/PPQN_SCALE)) c = 1;
					if (d>0)
					{
						if (lastD != d)
						{
							printf("\r\n\tRD %d", ((int)(d * SMALLEST_NOTE)/(int)PPQN_SCALE)+c);
						} else
						{
							printf(",_");
						}
						lastD = 0;
					}
				}
			}
			previousDelta = currentDelta;
			previousNote = c1;
			thisVelocity = c2 >> 3;
			NOTE_MODE = MODE_NOTE;
			break;
			
		case MODE_NOTE:
			//two note ons
			//printf("\nTwo note ONs\n");
			thisDuration = currentDelta;
			previousDelta = currentDelta;
			d = (float)thisDuration;
			a = (int)((d * SMALLEST_NOTE)/(int)PPQN_SCALE);
			c = 0;
			if (a!=((d*SMALLEST_NOTE)/PPQN_SCALE))
			{
				c = 1;
			}
			
			if (OUTPUT_VELOCITY>0)
			{
				//printf("\nthis=%d, previous=%d\n", thisVelocity, previousVelocity);
				if (abs(previousVelocity - thisVelocity)>=OUTPUT_VELOCITY)
				{
					printf("\r\n\tV %d",(int)thisVelocity);
					firstNoteOnLine = 1;
					newLine = 1;
					previousVelocity = thisVelocity;
					
				}
			}
			if (lastD != d)
			{
				printf("\r\n\tD %d",((int)(d * SMALLEST_NOTE)/(int)PPQN_SCALE)+c);
				firstNoteOnLine = 1;
				newLine = 1;
			}
			lastD = (int)d;
			previousDuration = thisDuration;
			if ((newLine == 1) || (noteCount>=NOTES_PER_LINE))
			{
				noteCount=0;
				firstNoteOnLine = 1;
				printf("\r\n\tdb ");
			}
			if (firstNoteOnLine!=1)
			{
				printf(",");
			}
			firstNoteOnLine = 0;
			newLine = 0;
			
			printf("%s",makeNote(previousNote));
			noteCount++;
			previousNote = c1;
			NOTE_MODE = MODE_NOTE;
			break;
			
		case MODE_REST:
			//printf("\nCurrent delta: %d\n",currentDelta);
			thisDuration = currentDelta; // - previousDelta;
			previousDelta = currentDelta;
			previousNote = c1;
			//previousVelocity = thisVelocity;
			thisVelocity = c2 >> 3;
			d = (float)thisDuration;
			a = (int)((d * SMALLEST_NOTE)/(int)PPQN_SCALE);
			c = 0;
			if (a>((d*SMALLEST_NOTE)/PPQN_SCALE))
			{
				c = 1;
			}
			d = a + c;
			
			//printf("\nD=%d lastD=%d\n", (int)d,lastD);
			if (d>0)
			{
				if (lastD != d)
				{					
					//printf("\r\n\tRD %d", ((int)(d * SMALLEST_NOTE)/(int)PPQN_SCALE)+c);
					printf("\r\n\tRD %d", (int)d);
					newLine = 1;
					firstNoteOnLine =1;
					noteCount = 0;
				} else
				{
					if ((noteCount>=NOTES_PER_LINE))
					{
						noteCount=0;
						firstNoteOnLine = 1;
						printf("\r\n\tdb ");
						newLine = 1;
					}
					
					
					if (newLine == 0) printf(",");
					newLine = 0;
					firstNoteOnLine = 0;
					//printf("\n\tR\n");
					printf("_");
					noteCount++;
				}
			}

			NOTE_MODE = MODE_NOTE;
			break;
			
		default:
			printf("\nERROR - shouldn't get here!\n");
			break;
	}
}			
	
	
void processNoteOff(unsigned char status, unsigned char c1, unsigned char c2)
{
	float d;
	int a,c;

	//printf("\nNOTE_OFF %d %d %d\n",status,c1,c2);
	switch (NOTE_MODE) {
		case MODE_NOTHING:
			//Note off before any note ons?
			printf("\nNote off before any note ons?\n");
			break;
			
		case MODE_NOTE:
			thisDuration = currentDelta;
			previousDelta = currentDelta;
			d = (float)thisDuration;
			a = (int)((d * SMALLEST_NOTE)/(int)PPQN_SCALE);
			c = 0;
			if (a!=((d*SMALLEST_NOTE)/PPQN_SCALE))
			{
				c = 1;
			}
			d=a+c;
			if (OUTPUT_VELOCITY>0)
			{
				//printf("\nthis=%d, previous=%d\n", thisVelocity, previousVelocity);
				if (abs(previousVelocity - thisVelocity)>=OUTPUT_VELOCITY)
				{
					printf("\r\n\tV %d",(int)thisVelocity);
					firstNoteOnLine = 1;
					newLine = 1;
					previousVelocity = thisVelocity;
					
				}
			}
			if (lastD != d)
			{
				//printf("\r\n\tD %d",((int)(d * SMALLEST_NOTE)/(int)PPQN_SCALE)+c);
				printf("\r\n\tD %d",(int)d);
				firstNoteOnLine = 1;
				newLine = 1;
			}
			lastD = (int)d;
			previousDuration = thisDuration;
			if ((newLine == 1) || (noteCount>=NOTES_PER_LINE))
			{
				noteCount=0;
				firstNoteOnLine = 1;
				printf("\r\n\tdb ");
			}
			if (firstNoteOnLine!=1)
			{
				printf(",");
			}
			firstNoteOnLine = 0;
			newLine = 0;
			
			printf("%s",makeNote(previousNote));
			noteCount++;
			previousNote = c1;
			NOTE_MODE = MODE_REST;
			break;
			
		case MODE_REST:
			//Error two note offs
			printf("\nTwo consecutive note OFFs?\n");
			break;

		default:
			break;
	}
	
}

//
//Make Note String from pitch value
//
char * makeNote(unsigned char pitch)
{
	static char * Notes [] =
	{ "C", "Cs", "D", "Ds", "E", "F", "Fs", "G",
	"Gs", "A", "As", "B" };
	static char buf[5];
	//if ( notes )
	sprintf (buf, "%s%d", Notes[pitch % 12], (pitch/12)-1);
	//else
	//sprintf (buf, "%d", pitch);
	return buf;
}

//
//Process Channel Message
//
void channelMessage(unsigned char status, unsigned char c1, unsigned char c2)
{
	//printf("Channel message: %02X %02X %02X\n\n", status, c1, c2);
	switch (status & 0xF0)
	{
		case NOTE_ON:
			if (c2>0)
			{
				processNoteOn(status, c1, c2);
			} else
			{
				//printf("\nUsing 0 velocity for note off\n");
				if (currentDelta>0)
				{
					processNoteOff(status, c1, c2);
				} else
				{
					//printf("\nError - some kind of overlap(1)\n");
					OVERLAP_FLAG=1;
				}
			}
			break;
			
		case NOTE_OFF:
			if (currentDelta>0)
			{
				processNoteOff(status, c1, c2);
			} else
			{
				//printf("\nError - some kind of overlap(2)\n");
				OVERLAP_FLAG=1;
			}
			break;
			
		case POLY_AFTERTOUCH:
		case CONTROL_CHANGE:
		case PROGRAM_CHANGE:
		case CHANNEL_AFTERTOUCH:
		case PITCH_WHEEL:
			break;
		default:
			break;
	}		
}

//
//Read byte from file
//
unsigned char readByte(FILE *file)
{
	unsigned char b;
	fread(&b,1,1,file);
	return b;
}

//
//Read Variable Length Number
//
unsigned int readVarLenNum(FILE *file)
{
	int i;
	unsigned char a[1];
	unsigned int r=0;;
	
	for (i=0;i<4;i++)
	{
		fread(a,1,1,file);
		r = r << 7;
		r = r | (a[0] & 0x7f);
		//printf("R: %d\n",r);
		if (!(a[0] & 0x80)) break;
	}
	
	return r;
}


//
//Read MIDI File Header
//
unsigned short readHeader(FILE *file)
{
	char s[5];
	readMT(s,inputFile);
	if (strncmp(s, MThd, 4) == 0)
	{
		MF_headerSize = read32bit(inputFile);
		MF_type = read16bit(inputFile);
		MF_numberOfTracks = read16bit(inputFile);
		MF_timeDivision = read16bit(inputFile);
		return 1;
	} else
	{
		return 0;
	}
	
}


//
//Read 16-bit value from file
//
unsigned short read16bit(FILE *file)
{
	int i;
	unsigned short r = 0;
	unsigned char a[sizeof(r)];
	
	fread(a,1,sizeof(r),file);
	for (i=0;i<sizeof(r);i++)
	{
		r = (r << 8)+a[i];
	}
	
	return r;
}
	

//
//Read 32-bit value from file
//
unsigned int read32bit(FILE *file)
{
	int i;
	unsigned int r = 0;
	unsigned char a[sizeof(r)];
		
	fread(a, 1, sizeof(r), file);
	
	for (i=0;i<sizeof(r);i++)
	{
		r = (r << 8)+a[i];
	}
		
	return r;
}

//
//Read "MT" chunk ID (4 bytes) from file
//
void readMT(char * strOut, FILE *file)
{
	char s[5];
	s[4]=0;
	fread (s, 1, 4, file);
	strncpy(strOut, s, 5);
}
	




