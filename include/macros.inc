/*
 *	Syntactic sugar 
 *
 *	$Id: macros.inc,v 1.2 2001/06/11 23:40:56 jani Exp $
 */


#define push(reg...)		stmdb sp!, {reg}
#define pop(reg...)		ldmia sp!, {reg}

#define cc_push(cc,reg...)	stm##cc##db sp!, {reg}
#define cc_pop(cc,reg...)	ldm##cc##ia sp!, {reg}

#define exit_on_error		teq	r0,#0;\
				bmi	exit

#define breakpoint		swi	0x9f0001

/*
this is obsoleted by new ELF generator stuff

#define bss(x,size)		x:	.word bss_##x;	\
				.section .bss;			\
				bss_##x : .fill size,1,0;\
				.previous
*/
#define bss(x,size)		x:	.space size
				
