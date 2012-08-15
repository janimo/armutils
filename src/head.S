/*
 * 	Simple head for Linux/ARM
 *
 *	$Id: head.S,v 1.3 2001-06-11 19:21:20 jani Exp $
 */

#include "includes.inc"

#define BUFSIZE	0x4000			
#define LINES	10


//r5 - file descriptor 
//r10 - number of lines shown
//r8 - temp reg,and safety buf

CODE
START
	mov	r5, #STDIN	
	mov	r10, #LINES
	pop 	(r3)			//number of args
	subs	r3, r3, #0x1			
	beq	doit			//if none assume defaults (STDIN and 10 lines)
	pop	(r1)
	pop	(r2)			//program name and first arg
	ldrb	r1,[r2]
	cmp	r1, #'-'		//is it line count or file name?
  	bne	file

	pop	(r2)

//convert line count from ASCII to int

	mov	r9, #0
	mov	r8, #10
next:
	ldrb	r7,[r2], #1		//get a character and advance buffer pointer
	subs	r7,r7, #'0'		//get the appropriate digit
	mlage	r10,r9,r8,r7		//multiply and accumulate
	mov	r9,r10			
	bge	next

	teq	r10,#0			//if line count is zero don't bother
	beq	exit

	subs	r3,r3, #2		//eat two more arguments
	beq	doit			//if no file name given assume STDIN
	pop	(r2)

file:
	mov	r0,r2			//r0 - address file name
	mov	r1, #O_RDONLY		//r1 - open mode
	sys_open
	exit_on_error
	mov	r5,r0

doit:
	adr	r1,buffer
	mov	r9,r1
	mov	r7,r1
	add	r8,r9, #BUFSIZE
	
readinput:	
	mov	r0,r5
	mov	r2, #BUFSIZE
	sys_read
	exit_on_error
	beq	find
	add	r1,r1,r0
	cmp	r1,r8
	ble	readinput

find:
	ldrb	r1,[r9], #1
	cmp	r1, #10			//is it a newline
	subeqs	r10,r10, #1		//if it is decrement linecount
	beq	writehead
	cmp	r9,r8
	blt	find	
	
writehead:
	mov	r0, #STDOUT
	mov	r1,r7
	sub	r2,r9,r7
	sys_write	
	
exit:
	sys_exit
UDATA
bss(buffer,BUFSIZE)
END
