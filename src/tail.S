/*
 * 	Simple tail for Linux/ARM
 *
 *	$Id: tail.S,v 1.8 2001-06-12 19:27:45 jani Exp $
 */

#include "includes.inc"

#define BUFSIZE	0x4000			 //16K - the maximum guarranteed size of the tail         
#define LINES	10

#define st_mode		#8
#define st_size		#20

@r5 - file descriptor 
@r10 - number of lines shown
@r8 - temp reg,and safety buf
@r9 -temp reg for load and store

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
	cmp	r1, #'-'		//is it line count or file name
  	bne	file

	pop	(r2)
@convert line count from ASCII to int
	mov	r9, #0
	mov	r8, #10
next:
	ldrb	r7,[r2], #1
	subs	r7,r7, #'0'
	mlage	r10,r9,r8,r7
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
	adr	r1,statbuf		//get stat info
	syscall(fstat)
	ldr	r2,[r1,st_mode]		//if regular file
	tst	r2, #S_IFREG
	beq	go
	ldr	r2,[r1,st_size]		//and file size>BUFSIZE
	subs	r1,r2, #BUFSIZE
	blt	go
	mov	r0,r5
	mov	r2, #SEEK_SET
	syscall(lseek)			//then seek to end

go:
	adr	r1,buffer
gogo:
	adr	r6,buffer
	add	r7,r6, #BUFSIZE
	add	r8,r6, #BUFSIZE * 2

readinput:	
	mov	r0,r5
	mov	r2, #BUFSIZE
	sys_read
	exit_on_error
	beq	writebuffer
	add	r1,r1,r0
	cmp	r1,r8
	ble	readinput

@copy buffers	- optimize this !!!!!

copybuf:	
	ldrb	r9,[r7],#1
	strb	r9,[r6],#1
	cmp	r1,r7
	bgt	copybuf
	sub	r1,r1, #BUFSIZE
	b	gogo

writebuffer:
	cmp	r1,r6
	beq exit
	mov	r2,r1
	sub	r1,r1, #1
search:
	ldrb	r9,[r1, #-1]!
	cmp	r1,r6
	beq	tail
	cmp	r9, #10			//newline character
	subeqs	r10,r10, #1
	bne	search

	add	r1,r1, #1
tail:
	mov	r0, #STDOUT
	sub	r2,r2,r1
	sys_write	
	
	
exit:
	sys_exit
UDATA

bss(statbuf,100)
bss(buffer,BUFSIZE)
bss(buffer2,BUFSIZE)
bss(guard,BUFSIZE)
END
