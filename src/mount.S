/*
 *	Simple mount.
 *
 *	$Id: sync.S,v 1.1 2001/06/11 19:21:20 jani Exp $
 */

#include "includes.inc"

CODE
START
	pop	(r0)		//argument count
	subs	r0, r0, #3
	bmi	exit
	pop	(r0)		//program name
	mov	r3,#0
	mov	r4,#0
	pop	(r0)		//device
	pop	(r1)		//mount point
	pop	(r2)		//fs type

	syscall(mount)
exit:
	sys_exit
UDATA
END
