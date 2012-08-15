/*
 * 	Simple ping for Linux/ARM
 *
 *	$Id: ping.S,v 1.7 2001-06-11 23:38:39 jani Exp $	
 */


#include "includes.inc"

@r5 - socket descriptor

CODE
START
	pop     (r0)			//number of args
	cmp	r0,#1			
	beq	exit			
	pop	(r1)			//progname
	pop	(r8)			//first arg - IP#
	mov	r0,r8
	bl	getip
	mov	r9,r5

	sub	r2,r0,r8
	mov	r1,r8
	mov	r0,#STDOUT
	sys_write	
	adr 	r1,sockdata
	sys_socket
	mov		r5,r0			//save fd
	adr		r7,senddata		//put in sendto arg 0
	str		r5,[r7]
	adr		r6,sockaddr		//fill sockaddr
	mov		r2,#0x10000		//family protocol
	orr		r2,r2,#2
	str		r2,[r6]
	mov		r2,r9
	str		r2,[r6,#4]
	//send packet
	adr	r1,senddata		//sock desc
	adr r2,packet	//packet
	str r2,[r7,#4]
	adr	r2,sockaddr
	str	r2,[r7,#16]	
	sys_sendto

recvl:	//wait for reply	
	add	r0,r5,#1
	adr	r1,fdset
	mov	r2,#1
	mov	r2,r2,LSL r5 
	str	r2,[r1]  
	mov	r2,#0
	mov	r3,#0
	adr	r4,timeout
	mov	r6,#5			//5 seconds timeout
	strb	r6,[r4]
	sys_select
	cmp	r0,#0
	beq	timedout	
	adr	r1,recvdata
	str	r5,[r1]
	mov	r2, #28
	str	r2,[r1,#8]	
	adr	r2,reply
	str	r2,[r1,#4]
	sys_recvfrom
	ldrb	r3,[r2,#20]		//type field in received packet
	cmp	r3,#0			//test if ECHO_REPLY
	bne	recvl
	adr	r1,mesgalive
	mov	r2,#11
	b	exit
timedout:
	adr	r1,mesgto
	mov	r2,#12
exit:	
	mov	r0,#STDOUT
	sys_write
	
	sys_exit


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ input : r0 -  pointer to ip in dotted 4 notation 	@
@ output: r5 -  ip number in network format		@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 	
getip:
	mov 	r1,#10		//for multiply	
	mov	r3,#'0'
	mov	r5,#0
	mov	r6,#0
cc:	mov	r10,#0		//accumulated IP
c:
	ldrb	r2,[r0],#1
	subs	r2,r2,r3
	blt	next
	mla	r4,r10,r1,r2	//r4 = r2 + r4*10
	mov	r10,r4
	b	c
next:	
	orr	r5,r5,r4,LSL r6
	add	r6,r6,#8
	cmp	r6,#32
	bne	cc
	mov	pc,lr
sockdata:
.int	AF_INET,SOCK_RAW,IPPROTO_ICMP			
senddata:
.int	0,0,8,0,0,16
packet:
.byte		0x08,00,0xf7,0xff,00,00,00,00
mesgalive:
.ascii		" is alive!\n"
mesgto:
.ascii		" timed out.\n"
UDATA
#undef bss
#define bss(x,y) x: .space  y
bss(sockaddr,16)
bss(reply,28)
bss(fdset,4)
bss(timeout,8)
bss(recvdata,24)

END
