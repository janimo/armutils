/*
 * 	Simple cat for Linux/ARM
 *
 *	$Id: cat.S,v 1.1 2001-06-12 13:00:49 jani Exp $
 */

#include "includes.inc"

#define BUFSIZE	0x4000			



CODE
START
	mov	r5, #STDIN	
	pop 	(r3)			//number of args
	subs	r3, r3, #0x1			
	beq	doit			//if none assume STDIN

	pop	(r0)			//program name

	pop	(r0)			//first arg - filename
	mov	r1, #O_RDONLY		//r1 - open mode
	sys_open
	exit_on_error
	mov	r5,r0

doit:
	adr	r1,buffer	

readinput:	
	mov	r0,r5
	mov	r2, #BUFSIZE
	sys_read
	exit_on_error
	beq	exit
	mov	r2,r0
	mov	r0, #STDOUT
	sys_write	
	b	readinput
	
exit:
	sys_exit
UDATA
bss(buffer,BUFSIZE)
END
