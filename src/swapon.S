/*
 *	Simple swapon/swapoff.
 *
 *	$Id$
 */

#include "includes.inc"

CODE
START
	pop (r3)	//argument count
	pop (r3)	//program name
parse:
	mov	r5,r4
	ldrb	r4,[r3],#1
	teq	r4, #0
	bne	parse		//go to end of command name

loop:
	pop (r0)		//get device name
	teq r0,#0
	beq exit

	cmp	r5,#'f'

	cc_syscall(ne,swapon)
	cc_syscall(eq,swapoff)
	b loop			//next device

exit:
	sys_exit

UDATA
END
