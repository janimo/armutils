/*
 *	Miscellaneous defines from the standard C include files
 *
 *	$Id: defines.h,v 1.1 2001/06/11 23:40:56 jani Exp $
 */

#define STDIN		0
#define STDOUT		1
#define STDERR		2

/*	linux/in.h	*/

#define	IPPROTO_IP	0
#define IPPROTO_ICMP	1
#define	IPPROTO_TCP	6
#define IPPROTO_UDP	17
#define IPPROTO_RAW	255

#define INADDR_ANY	0
/*	linux/socket	*/

#define AF_UNIX		1
#define AF_INET		2
#define SOL_TCP		6
/*	asm/socket.h	*/

#define SOCK_STREAM 1       /* stream (connection) socket   */
#define SOCK_DGRAM  2       /* datagram (conn.less) socket  */
#define SOCK_RAW    3       /* raw socket           */
#define SOCK_PACKET 10    


/*	asm/fcntl.h	*/

#define O_RDONLY	0
#define O_WRONLY	1
#define O_RDWR		2


/*	sys/stat.h	*/
#define	S_IFDIR	0040000	/* Directory.  */
#define	S_IFCHR	0020000	/* Character device.  */
#define	S_IFBLK	0060000	/* Block device.  */
#define	S_IFREG	0100000	/* Regular file.  */
#define	S_IFIFO	0010000	/* FIFO.  */

/*	asm/unistd.h	*/
#define SEEK_SET	0	/* Seek from beginning of file.  */
#define SEEK_CUR	1	/* Seek from current position.  */
#define SEEK_END	2	/* Seek from end of file.  */

/* asm/signal.h	*/

#define SIGHUP		 1
#define SIGINT		 2
#define SIGQUIT		 3
#define SIGILL		 4
#define SIGTRAP		 5
#define SIGABRT		 6
#define SIGIOT		 6
#define SIGBUS		 7
#define SIGFPE		 8
#define SIGKILL		 9
#define SIGUSR1		10
#define SIGSEGV		11
#define SIGUSR2		12
#define SIGPIPE		13
#define SIGALRM		14
#define SIGTERM		15
#define SIGSTKFLT	16
#define SIGCHLD		17
#define SIGCONT		18
#define SIGSTOP		19
#define SIGTSTP		20
#define SIGTTIN		21
#define SIGTTOU		22
#define SIGURG		23
#define SIGXCPU		24
#define SIGXFSZ		25
#define SIGVTALRM	26
#define SIGPROF		27
#define SIGWINCH	28
#define SIGIO		29
#define SIGPOLL		SIGIO
/*
#define SIGLOST		29
*/
#define SIGPWR		30
#define SIGSYS		31
#define	SIGUNUSED	31


