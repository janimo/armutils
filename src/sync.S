/*
 *	Trivial sync.It can't get neither simpler nor more complicated.
 *
 *	$Id: sync.S,v 1.1 2001-06-11 19:21:20 jani Exp $
 */

#include "includes.inc"

CODE
START
	syscall(sync)
	sys_exit
UDATA
END
