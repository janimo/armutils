/*
	ARMutils	-	elf.inc	

	definitions pertaining to the generation of the ELF program layout	
	
	$Id: elf.inc,v 1.1 2001-06-10 23:16:08 jani Exp $
*/

 
#define CLASS32		1			//ELF 32 bit class 
#define VERSION		1			//current (so far the only) version
#define LITTLE		1			//little endian encoding		
#define OSABIARM	0x61			//magic for ARM ABI

#define EXEC		2			//executable file
#define PROC_ARM	40			//for the ARM processor
#define ADDR		0x2000000		//load address
#define ENTRY		_start 			//entry point

#define HDRSZ		52			//size of ELF header
#define SHOFF		0			//offset to section header table (we have no sections) 
#define PHOFF		52			//offset to program header table
#define PHNUM		1			//number of program headers
#define PHSIZE		32			//size of a program header
#define FLAGS		0

//this macro emits a correct ELF header for ARM
#define ELF_HEADER	\
.byte 0x7f,'E','L','F',CLASS32,LITTLE,VERSION,OSABIARM;	\
.fill 8,1,0					;	\
						;	\
.short EXEC					;	\
.short PROC_ARM					;	\
.int VERSION					;	\
.int ENTRY 					;	\
.int PHOFF					;	\
.int SHOFF					;	\
.int FLAGS					;	\
.short HDRSZ 					;	\
.short PHSIZE 					;	\
.short PHNUM					;	\
.short 0,0,0					;	\

#define LOAD		1			//LOAD type segment
#define FILEOFF		0			//offset in file
#define PFLAGS		7			//rwx	
#define FILESIZE udatalabel-startlabel		//size in file is size of code
#define DATASIZE endlabel-udatalabel		//size of uninitialised data
#define ALIGN 0x1000				//page size = 4K

//this macro emits  a program header for a rwx loadable segment
#define PHEADER		\
.int LOAD	;	\
.int FILEOFF 	;	\
.int ADDR 	;	\
.int ADDR 	;	\
.int FILESIZE	;	\
.int FILESIZE+DATASIZE;	\
.int PFLAGS 	;	\
.int ALIGN;


//declare the program entry point
#define START	.global _start;\
		_start:
//declare start of code segment
#define CODE	startlabel:\
		ELF_HEADER\
		PHEADER

//declare start of data segment
#define UDATA	.balign 4;\
		udatalabel:

//declare end of file
#define END	endlabel:
