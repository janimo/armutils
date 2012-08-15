/*
 *	Removes "bss" part of ARMutils executables.Until a more elegant solution
 *	(preferably assembly-time) comes up, this is needed so that only p_filesz
 *	bytes remain in the file.p_filesz is in the program  header.
 *	
 *	$Id: trunc.c,v 1.1 2001-06-11 23:41:44 jani Exp $
 */ 

#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char * args[])
{
	int fd;
	int i;
	char buf[52+32];

	if (argc < 2) {
		printf("Usage: strip filename\n");
		exit(1);
	}
	for (i = 1;i<argc;i++) {

	if ((fd = open(args[i],O_RDWR)) == -1) {
		perror("Error opening file");
		exit(1);
	}
	if (read(fd,buf,84) == -1) {
		perror("Error reading file");
		exit(1);
	}
	if (ftruncate(fd,*(int *)(buf+52+16)) == -1) {
		perror("Error truncating file");
		exit(1);
	}

	close(fd);

	}
	return 0;
		
}
