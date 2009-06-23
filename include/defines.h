/*
 *	Miscellaneous defines from the standard C include files
 *
 *	$Id: defines.h,v 1.1 2001-06-11 23:40:56 jani Exp $
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

/*	unistd.h	*/
# define SEEK_SET	0	/* Seek from beginning of file.  */
# define SEEK_CUR	1	/* Seek from current position.  */
# define SEEK_END	2	/* Seek from end of file.  */

