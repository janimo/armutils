/*
 * 	Simple httpd for Linux/ARM
 *
 *	$Id: httpd.S,v 1.4 2001-06-12 19:27:45 jani Exp $
 */

#include "includes.inc"

@r9	 port number
@r5 - socket descriptor 

CODE
START
	mov	r9,#0x1f00		//the default port
	orr 	r9,r9,#0x90

	pop 	(r0)			//number of args
	cmp	r0, #1			
	beq	doit			
	pop	(r0)			//progname
	pop	(r10)			//port 
	b	ascii2int
back:
doit:
	mov	r10,r9,LSR #8		//transform port number to network order
	bic	r9,r9,#0xff00
	orr	r10,r10,r9,LSL #8

	adr	r1,sockdata	
	sys_socket

	mov	r5,r0			//save socket descriptor
	
	adr	r1,binddata
	str	r5,[r1]
	adr	r2,sockaddr
	strh	r10,[r2,#2]
	str	r2,[r1,#4]
	sys_bind

	adr	r1,listendata
	str	r5,[r1]
	sys_listen
	mov	r10,r5
acceptloop:
	adr	r1,acceptdata
	str	r10,[r1]
	adr	r2,sockaddr
	str	r2,[r1,#4]
	adr	r2,len
	str	r2,[r1,#8]	
	sys_accept
	push(r0)
	sys_fork
	teq	r0,#0
	
	cc_syscall(ne,close)
	bne	acceptloop		//if parent process go to accept()
	pop(r0)			
	mov	r7,#0			//if child start serving!
	mov	r5,r0
@ set TCP_CORK option 
	adr	r1,corkdata
	str	r0,[r1]
	adr	r2,cork
	str	r2,[r1,#12]
	sys_setsockopt
	
rh:
	mov	r0,r5
	adr	r1,buf
	add	r9,r1,#5	@GET urlhere
	mov	r2,#1000
	sys_read
	tst	r0,r0
	bmi	exit
	add	r0,r0,#1
	mov	r6,#0
n:	ldrb	r4,[r1,r6]
	cmp	r4,#' '
	moveq	r4,#0	
	streqb	r4,[r1,r6]
 	cmp	r4,#13
	cmpne	r4,#10
	addeq	r7,r7,#1
	movne	r7,#0
	cmp	r7,#4
	beq	out
	add	r6,r6,#1
	cmp	r0,r6
	beq	rh
	b	n

out:
	mov	r0,r9
	mov	r1,#O_RDONLY
	sys_open
	mov	r6,r0
@header	
	mov	r0,r5		
	adr	r1,header
	mov	r2,#43	
	sys_write
@file
	mov	r0,r5
	mov	r1,r6
	adr	r2,flen
	mov	r3,#0
	str 	r3,[r2]
	mov	r3,#0x10000
	syscall(sendfile) 
	mov	r0,r5		//close socket
	sys_close
	mov	r0,r6		//close file
	sys_close
	
//	b	acceptloop
exit:
	syscall(exit)

@transform ascii port number to network order integer
	
ascii2int:
	mov	r7,#0
	mov	r8,#10
next:	
	ldrb	r6,[r10],#1
	subs	r6,r6,#'0'
	mlage	r9,r7,r8,r6
	mov	r7,r9
	bge	next
	b back
	
sockdata:
	.int	AF_INET,SOCK_STREAM,IPPROTO_TCP
binddata:
	.int	0,0,16
sockaddr:
	.short	AF_INET,0
	.int INADDR_ANY
listendata:
	.int	0,3	//backlog of 3 to listen
corkdata:
	.int 0,SOL_TCP,3,0,4
cork:
	.int 1
header:
.ascii	"HTTP/1.0 200 OK\nContent-type: text/plain\n\n\n"

UDATA

bss(acceptdata,12)
bss(len,4)
bss(flen,4)
bss(buf,1000)

END

