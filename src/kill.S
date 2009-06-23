/*
 * 	Simple kill for Linux/ARM
 *
 *	$Id: kill.S,v 1.1 2001-06-12 13:00:49 jani Exp $
 */

#include "includes.inc"


//register aliases

pid	.req	r0
sig	.req	r1

CODE
START
	mov	sig, #SIGTERM			
	pop 	(r3)			//number of args
	subs	r3, r3, #1			
	beq	exit			//if none get out
	pop	(r2)			//program name
	subs	r3,r3, #1
	beq	getpid			

	pop	(r2)			
	add	r2,r2,#1		//go past '-'
	bl 	ascii2int
	mov	sig,r5			//signal number

getpid:
	pop	(r2)
	bl	ascii2int
	mov	pid,r5			//process id	
	
	sys_kill	
exit:
	sys_exit

//get pointer to buffer in r2
//put converted int in r5

ascii2int:
	mov	r6, #0
	mov	r8, #10
next:
	ldrb	r7,[r2], #1		//get a character and advance buffer pointer
	subs	r7,r7, #'0'		//get the appropriate digit
	mlage	r5,r6,r8,r7		//multiply and accumulate
	mov	r6,r5			
	bge	next
	mov	pc,lr			//return from call	

UDATA
END
