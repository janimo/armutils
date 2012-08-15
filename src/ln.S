/*
 *	Simple ln.
 *
 *	$Id$
 */

#include "includes.inc"

CODE
START
	pop (r3)	//argument count

	subs r3,r3,#2
	bmi	exit

	cmp	r3,#2	//if equal then symbolic link

	cc_pop (eq,r0)	//should be  '-s', don't check it
	pop (r0)	//program name

	pop (r0)
	pop (r1)
	cc_syscall(ne,link)
	cc_syscall(eq,symlink)

exit:
	sys_exit

UDATA
END
