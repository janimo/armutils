/*
 *	Simple mkdir/rmdir.
 *
 *	$Id: sync.S,v 1.1 2001/06/11 19:21:20 jani Exp $
 */

#include "includes.inc"

CODE
START
	pop	(r0)		//argument count
	subs	r0, r0, #1
	beq	exit

	pop	(r2)		//program name
	pop	(r0)		//directory name

	mov	r1, #0x100	//set 0755 permission
	orr	r1,r1, #0xed

parse:
	ldrb	r3,[r2],#1		//is it rmdir or mkdir?
	cmp	r3, #'a'
	bmi	parse

	cmp	r3,#'r'
	cc_syscall(ne,mkdir)
	cc_syscall(eq,rmdir)
exit:
	sys_exit
UDATA
END
