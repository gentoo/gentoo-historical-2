#if !defined(lint) && !defined(DOS)
static char rcsid[] = "$Id: filter.c,v 1.1 2000/11/15 16:46:06 achim Exp $";
#endif
/*----------------------------------------------------------------------

            T H E    P I N E    M A I L   S Y S T E M

   Laurence Lundblade and Mike Seibel
   Networks and Distributed Computing
   Computing and Communications
   University of Washington
   Administration Builiding, AG-44
   Seattle, Washington, 98195, USA
   Internet: lgl@CAC.Washington.EDU
             mikes@CAC.Washington.EDU

   Please address all bugs and comments to "pine-bugs@cac.washington.edu"


   Pine and Pico are registered trademarks of the University of Washington.
   No commercial use of these trademarks may be made without prior written
   permission of the University of Washington.

   Pine, Pico, and Pilot software and its included text are Copyright
   1989-1999 by the University of Washington.

   The full text of our legal notices is contained in the file called
   CPYRIGHT, included with this distribution.


   Pine is in part based on The Elm Mail System:
    ***********************************************************************
    *  The Elm Mail System  -  Revision: 2.13                             *
    *                                                                     *
    * 			Copyright (c) 1986, 1987 Dave Taylor              *
    * 			Copyright (c) 1988, 1989 USENET Community Trust   *
    ***********************************************************************


  ----------------------------------------------------------------------*/

/*======================================================================
     filter.c

     This code provides a generalized, flexible way to allow
     piping of data thru filters.  Each filter is passed a structure
     that it will use to hold its static data while it operates on
     the stream of characters that are passed to it.  After processing
     it will either return or call the next filter in
     the pipe with any character (or characters) it has ready to go. This
     means some terminal type of filter has to be the last in the
     chain (i.e., one that writes the passed char someplace, but doesn't
     call another filter).

     See below for more details.

     The motivation is to handle MIME decoding, richtext conversion,
     iso_code stripping and anything else that may come down the
     pike (e.g., PEM) in an elegant fashion.  mikes (920811)

   TODO:
       reasonable error handling

  ====*/


#include "headers.h"


/*
 * Internal prototypes
 */
int	gf_so_readc PROTO((unsigned char *));
int	gf_so_writec PROTO((int));
int	gf_sreadc PROTO((unsigned char *));
int	gf_swritec PROTO((int));
int	gf_freadc PROTO((unsigned char *));
int	gf_fwritec PROTO((int));
void	gf_terminal PROTO((FILTER_S *, int));
char   *gf_filter_puts PROTO((char *));
void	gf_filter_eod PROTO((void));
void    gf_error PROTO((char *));
void	gf_8bit_put PROTO((FILTER_S *, int));
int	so_reaquire PROTO((STORE_S *));
void   *so_file_open PROTO((STORE_S *));
int	so_cs_writec PROTO((int, STORE_S *));
int	so_pico_writec PROTO((int, STORE_S *));
int	so_file_writec PROTO((int, STORE_S *));
int	so_cs_readc PROTO((unsigned char *, STORE_S *));
int	so_pico_readc PROTO((unsigned char *, STORE_S *));
int	so_file_readc PROTO((unsigned char *, STORE_S *));
int	so_cs_puts PROTO((STORE_S *, char *));
int	so_pico_puts PROTO((STORE_S *, char *));
int	so_file_puts PROTO((STORE_S *, char *));


/*
 * GENERALIZED STORAGE FUNCTIONS.  Idea is to allow creation of
 * storage objects that can be written into and read from without
 * the caller knowing if the storage is core or in a file
 * or whatever.
 */
#define	MSIZE_INIT	8192
#define	MSIZE_INC	4096


/*
 * System specific options
 */
#ifdef	DOS
#define	NO_PIPE
#endif
#if	defined(DOS) || defined(OS2)
#define CRLF_NEWLINES
#endif

/*
 * Various parms for opening and creating files directly and via stdio.
 * NOTE: If "binary" mode file exists, use it.
 */
#ifdef	O_BINARY
#define STDIO_READ	"rb"
#define STDIO_APPEND	"a+b"
#else
#define	O_BINARY	0
#define	STDIO_READ	"r"
#define	STDIO_APPEND	"a+"
#endif

#define	OP_FL_RDWR	(O_RDWR | O_CREAT | O_APPEND | O_BINARY)
#define	OP_FL_RDONLY	(O_RDONLY | O_BINARY)

#ifdef	S_IREAD
#define	OP_MD_USER	(S_IREAD | S_IWRITE)
#else
#define	OP_MD_USER	0600
#endif

#ifdef	S_IRUSR
#define	OP_MD_ALL	(S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | \
			 S_IROTH | S_IWOTH)
#else
#define	OP_MD_ALL	0666
#endif


/*
 * allocate resources associated with the specified type of
 * storage.  If requesting a named file object, open it for
 * appending, else just open a temp file.
 *
 * return the filled in storage object
 */
STORE_S *
so_get(source, name, rtype)
    SourceType  source;			/* requested storage type */
    char       *name;			/* file name 		  */
    int		rtype;			/* file access type	  */
{
    STORE_S *so = (STORE_S *)fs_get(sizeof(STORE_S));

    memset(so, 0, sizeof(STORE_S));
    so->flags |= rtype;

    if(name)					/* stash the name */
      so->name = cpystr(name);
#ifdef	DOS
    else if(source == TmpFileStar || source == FileStar){
	/*
	 * Coerce to TmpFileStar.  The MSC library's "tmpfile()"
	 * doesn't observe the "TMP" or "TEMP" environment vars and
	 * always wants to write "\".  This is problematic in shared,
	 * networked environments.
	 */
	source   = TmpFileStar;
	so->name = temp_nam(NULL, "pi");
    }
#else
    else if(source == TmpFileStar)		/* make one up! */
      so->name = temp_nam(NULL, "pine-tmp");
#endif

    so->src = source;
    if(so->src == FileStar || so->src == TmpFileStar){
	so->writec = so_file_writec;
	so->readc  = so_file_readc;
	so->puts   = so_file_puts;

	/*
	 * The reason for both FileStar and TmpFileStar types is
	 * that, named or unnamed, TmpFileStar's are unlinked
	 * when the object is given back to the system.  This is
	 * useful for keeping us from running out of file pointers as
	 * the pointer associated with the object can be temporarily
	 * returned to the system without destroying the object.
	 *
	 * The programmer is warned to be careful not to assign the
	 * TmpFileStar type to any files that are expected to remain
	 * after the dust has settled!
	 */
	if(so->name){
	    if(!(so->txt = so_file_open(so))){
		dprint(1, (debugfile, "so_get error: %s : %s", so->name,
			   error_description(errno)));
		fs_give((void **)&so->name);
		fs_give((void **)&so); 		/* so freed & set to NULL */
	    }
	}
	else{
	    if(!(so->txt = (void *) create_tmpfile())){
		dprint(1, (debugfile, "so_get error: tmpfile : %s",
			   error_description(errno)));
		fs_give((void **)&so);		/* so freed & set to NULL */
	    }
	}
    }
    else if(so->src == PicoText){
	so->writec = so_pico_writec;
	so->readc  = so_pico_readc;
	so->puts   = so_pico_puts;
	if(!(so->txt = pico_get())){
	    dprint(1, (debugfile, "so_get error: alloc of pico text space"));
	    if(so->name)
	      fs_give((void **)&so->name);
	    fs_give((void **)&so);		/* so freed & set to NULL */
	}
    }
    else{
	so->writec = so_cs_writec;
	so->readc  = so_cs_readc;
	so->puts   = so_cs_puts;
	so->txt	   = (void *)fs_get((size_t) MSIZE_INIT * sizeof(char));
	so->dp	   = so->eod = (unsigned char *) so->txt;
	so->eot	   = so->dp + MSIZE_INIT;
	memset(so->eod, 0, so->eot - so->eod);
    }

    return(so);
}


/*
 * so_give - free resources associated with a storage object and then
 *           the object itself.
 */
void
so_give(so)
STORE_S **so;
{
    if(!so)
      return;

    if((*so)->src == FileStar || (*so)->src == TmpFileStar){
        if((*so)->txt)
	  fclose((FILE *)(*so)->txt);	/* disassociate from storage */

	if((*so)->name && (*so)->src == TmpFileStar)
	  unlink((*so)->name);		/* really disassociate! */
    }
    else if((*so)->txt && (*so)->src == PicoText)
      pico_give((*so)->txt);
    else if((*so)->txt)
      fs_give((void **)&((*so)->txt));

    if((*so)->name)
      fs_give((void **)&((*so)->name));	/* blast the name            */

    fs_give((void **)so);		/* release the object        */
}


/*
 * so_file_open
 */
void *
so_file_open(so)
    STORE_S *so;
{
    char *type  = ((so->flags) & WRITE_ACCESS) ? STDIO_APPEND : STDIO_READ;
    int   flags = ((so->flags) & WRITE_ACCESS) ? OP_FL_RDWR : OP_FL_RDONLY,
	  mode  = (((so->flags) & OWNER_ONLY) || so->src == TmpFileStar)
		   ? OP_MD_USER : OP_MD_ALL,
	  fd;

    /*
     * Use open instead of fopen so we can make temp files private.
     */
    return(((fd = open(so->name, flags, mode)) >= 0)
	     ? (so->txt = (void *) fdopen(fd, type)) : NULL);
}


/*
 * put a character into the specified storage object,
 * expanding if neccessary
 *
 * return 1 on success and 0 on failure
 */
int
so_cs_writec(c, so)
    int      c;
    STORE_S *so;
{
    if(so->dp >= so->eot){
	size_t cur_o  = so->dp - (unsigned char *) so->txt;
	size_t data_o = so->eod - (unsigned char *) so->txt;
	size_t size   = (so->eot - (unsigned char *) so->txt) + MSIZE_INC;

	fs_resize(&so->txt, size * sizeof(char));
	so->dp   = (unsigned char *) so->txt + cur_o;
	so->eod  = (unsigned char *) so->txt + data_o;
	so->eot  = (unsigned char *) so->txt + size;
	memset(so->eod, 0, so->eot - so->eod);
    }

    *so->dp++ = (unsigned char) c;
    if(so->dp > so->eod)
      so->eod = so->dp;

    return(1);
}

int
so_pico_writec(c, so)
    int      c;
    STORE_S *so;
{
    unsigned char ch = (unsigned char) c;

    return(pico_writec(so->txt, ch));
}

int
so_file_writec(c, so)
    int      c;
    STORE_S *so;
{
    unsigned char ch = (unsigned char) c;
    int rv = 0;

    if(so->txt || so_reaquire(so))
      do
	rv = fwrite(&ch,sizeof(unsigned char),(size_t)1,(FILE *)so->txt);
      while(!rv && ferror((FILE *)so->txt) && errno == EINTR);

    return(rv);
}


/*
 * get a character from the specified storage object.
 *
 * return 1 on success and 0 on failure
 */
int
so_cs_readc(c, so)
    unsigned char *c;
    STORE_S       *so;
{
    return((so->dp < so->eod) ? *c = *(so->dp)++, 1 : 0);
}

int
so_pico_readc(c, so)
    unsigned char *c;
    STORE_S       *so;
{
    return(pico_readc(so->txt, c));
}

int
so_file_readc(c, so)
    unsigned char *c;
    STORE_S       *so;
{
    int rv = 0;

    if(so->txt || so_reaquire(so))
      do
	rv = fread(c, sizeof(char), (size_t)1, (FILE *)so->txt);
      while(!rv && ferror((FILE *)so->txt) && errno == EINTR);

    return(rv);
}


/*
 * write a string into the specified storage object,
 * expanding if necessary (and cheating if the object
 * happens to be a file!)
 *
 * return 1 on success and 0 on failure
 */
int
so_cs_puts(so, s)
    STORE_S *so;
    char    *s;
{
    int slen = strlen(s);

    if(so->dp + slen >= so->eot){
	register size_t cur_o  = so->dp - (unsigned char *) so->txt;
	register size_t data_o = so->eod - (unsigned char *) so->txt;
	register size_t len   = so->eot - (unsigned char *) so->txt;
	while(len <= cur_o + slen + 1)
	  len += MSIZE_INC;		/* need to resize! */

	fs_resize(&so->txt, len * sizeof(char));
	so->dp	 = (unsigned char *)so->txt + cur_o;
	so->eod	 = (unsigned char *)so->txt + data_o;
	so->eot	 = (unsigned char *)so->txt + len;
	memset(so->eod, 0, so->eot - so->eod);
    }

    memcpy(so->dp, s, slen);
    so->dp += slen;
    if(so->dp > so->eod)
      so->eod = so->dp;

    return(1);
}

int
so_pico_puts(so, s)
    STORE_S *so;
    char    *s;
{
    return(pico_puts(so->txt, s));
}

int
so_file_puts(so, s)
    STORE_S *so;
    char    *s;
{
    int rv = *s ? 0 : 1;

    if(!rv && (so->txt || so_reaquire(so)))
      do
	rv = fwrite(s, strlen(s)*sizeof(char), (size_t)1, (FILE *)so->txt);
      while(!rv && ferror((FILE *)so->txt) && errno == EINTR);

    return(rv);
}


/*
 *
 */
int
so_nputs(so, s, n)
    STORE_S *so;
    char    *s;
    long     n;
{
    while(n--)
      if(!so_writec((unsigned char) *s++, so))
	return(0);		/* ERROR putting char ! */

    return(1);
}



/*
 * Position the storage object's pointer to the given offset
 * from the start of the object's data.
 */
int
so_seek(so, pos, orig)
    STORE_S *so;
    long     pos;
    int      orig;
{
    if(so->src == CharStar){
	switch(orig){
	    case 0 :				/* SEEK_SET */
	      return((pos < so->eod - (unsigned char *) so->txt)
		      ? so->dp = (unsigned char *)so->txt + pos, 0 : -1);
	    case 1 :				/* SEEK_CUR */
	      return((pos > 0)
		       ? ((pos < so->eod - so->dp) ? so->dp += pos, 0: -1)
		       : ((pos < 0)
			   ? ((-pos < so->dp - (unsigned char *)so->txt)
			        ? so->dp += pos, 0 : -1)
			   : 0));
	    case 2 :				/* SEEK_END */
	      return((pos < so->eod - (unsigned char *) so->txt)
		      ? so->dp = so->eod - pos, 0 : -1);
	    default :
	      return(-1);
	}
    }
    else if(so->src == PicoText)
      return(pico_seek(so->txt, pos, orig));
    else			/* FileStar or TmpFileStar */
      return((so->txt || so_reaquire(so))
		? fseek((FILE *)so->txt,pos,orig)
		: -1);
}


/*
 * Change the given storage object's size to that specified.  If size
 * is less than the current size, the internal pointer is adjusted and
 * all previous data beyond the given size is lost.
 *
 * Returns 0 on failure.
 */
int
so_truncate(so, size)
    STORE_S *so;
    long     size;
{
    if(so->src == CharStar){
	if(so->eod < (unsigned char *) so->txt + size){	/* alloc! */
	    unsigned char *newtxt = (unsigned char *) so->txt;
	    register size_t len   = so->eot - (unsigned char *) so->txt;

	    while(len <= size)
	      len += MSIZE_INC;		/* need to resize! */

	    if(len > so->eot - (unsigned char *) newtxt){
		fs_resize((void **) &newtxt, len * sizeof(char));
		so->eot = newtxt + len;
		so->eod = newtxt + (so->eod - (unsigned char *) so->txt);
		memset(so->eod, 0, so->eot - so->eod);
	    }

	    so->eod = newtxt + size;
	    so->dp  = newtxt + (so->dp - (unsigned char *) so->txt);
	    so->txt = newtxt;
	}
	else if(so->eod > (unsigned char *) so->txt + size){
	    if(so->dp > (so->eod = (unsigned char *)so->txt + size))
	      so->dp = so->eod;

	    memset(so->eod, 0, so->eot - so->eod);
	}

	return(1);
    }
    else if(so->src == PicoText){
	fatal("programmer botch: unsupported so_truncate call");
	/*NOTREACHED*/
    }
    else			/* FileStar or TmpFileStar */
      return(fflush((FILE *) so->txt) != EOF
	     && fseek((FILE *) so->txt, size, 0) == 0
	     && ftruncate(fileno((FILE *)so->txt), size) == 0);
}


/*
 * so_release - a rather misnamed function.  the idea is to release
 *              what system resources we can (e.g., open files).
 *              while maintaining a reference to it.
 *              it's up to the functions that deal with this object
 *              next to re-aquire those resources.
 */
int
so_release(so)
STORE_S *so;
{
    if(so->txt && so->name && (so->src == FileStar || so->src == TmpFileStar)){
	if(fgetpos((FILE *)so->txt, (fpos_t *)&(so->used)) == 0){
	    fclose((FILE *)so->txt);		/* free the handle! */
	    so->txt = NULL;
	}
    }

    return(1);
}


/*
 * so_reaquire - get any previously released system resources we
 *               may need for the given storage object.
 *       NOTE: at the moment, only FILE * types of objects are
 *             effected, so it only needs to be called before
 *             references to them.
 *
 */
so_reaquire(so)
STORE_S *so;
{
    int   rv = 1;

    if(!so->txt && (so->src == FileStar || so->src == TmpFileStar)){
	if(!(so->txt = so_file_open(so))){
	    q_status_message2(SM_ORDER,3,5, "ERROR reopening %s : %s", so->name,
				error_description(errno));
	    rv = 0;
	}
	else if(fsetpos((FILE *)so->txt, (fpos_t *)&(so->used))){
	    q_status_message2(SM_ORDER, 3, 5, "ERROR positioning in %s : %s",
				so->name, error_description(errno));
	    rv = 0;
	}
    }

    return(rv);
}


/*
 * so_text - return a pointer to the text the store object passed
 */
void *
so_text(so)
STORE_S *so;
{
    return((so) ? so->txt : NULL);
}


/*
 * END OF GENERALIZE STORAGE FUNCTIONS
 */


/*
 * Start of filters, pipes and various support functions
 */

/*
 * pointer to first function in a pipe, and pointer to last filter
 */
FILTER_S         *gf_master = NULL;
static	gf_io_t   last_filter;
static	char     *gf_error_string;
static	long	  gf_byte_count;
static	jmp_buf   gf_error_state;


/*
 * A list of states used by the various filters.  Reused in many filters.
 */
#define	DFL	0
#define	EQUAL	1
#define	HEX	2
#define	WSPACE	3
#define	CCR	4
#define	CLF	5
#define	TOKEN	6
#define	TAG	7
#define	HANDLE	8
#define	HDATA	9



/*
 * Macros to reduce function call overhead associated with calling
 * each filter for each byte filtered, and to minimize filter structure
 * dereferences.  NOTE: "queuein" has to do with putting chars into the
 * filter structs data queue.  So, writing at the queuein offset is
 * what a filter does to pass processed data out of itself.  Ditto for
 * queueout.  This explains the FI --> queueout init stuff below.
 */
#define	GF_QUE_START(F)	(&(F)->queue[0])
#define	GF_QUE_END(F)	(&(F)->queue[GF_MAXBUF - 1])

#define	GF_IP_INIT(F)	ip  = (F) ? &(F)->queue[(F)->queuein] : NULL
#define	GF_EIB_INIT(F)	eib = (F) ? GF_QUE_END(F) : NULL
#define	GF_OP_INIT(F)	op  = (F) ? &(F)->queue[(F)->queueout] : NULL
#define	GF_EOB_INIT(F)	eob = (F) ? &(F)->queue[(F)->queuein] : NULL

#define	GF_IP_END(F)	(F)->queuein  = ip - GF_QUE_START(F)
#define	GF_OP_END(F)	(F)->queueout = op - GF_QUE_START(F)

#define	GF_INIT(FI, FO)	register unsigned char *GF_OP_INIT(FI);	 \
			register unsigned char *GF_EOB_INIT(FI); \
			register unsigned char *GF_IP_INIT(FO);  \
			register unsigned char *GF_EIB_INIT(FO);

#define	GF_CH_RESET(F)	(op = eob = GF_QUE_START(F), \
					    (F)->queueout = (F)->queuein = 0)

#define	GF_END(FI, FO)	(GF_OP_END(FI), GF_IP_END(FO))

#define	GF_FLUSH(F)	((int)(GF_IP_END(F), (*(F)->f)((F), GF_DATA), \
			       GF_IP_INIT(F), GF_EIB_INIT(F)))

#define	GF_PUTC(F, C)	((int)(*ip++ = (C), (ip >= eib) ? GF_FLUSH(F) : 1))

#define	GF_GETC(F, C)	((op < eob) ? (((C) = *op++), 1) : GF_CH_RESET(F))


/*
 * Generalized getc and putc routines.  provided here so they don't
 * need to be re-done elsewhere to
 */

/*
 * pointers to objects to be used by the generic getc and putc
 * functions
 */
static struct gf_io_struct {
    FILE          *file;
    char          *txtp;
    unsigned long  n;
} gf_in, gf_out;


#define	GF_SO_STACK	struct gf_so_stack
static GF_SO_STACK {
    STORE_S	*so;
    GF_SO_STACK *next;
} *gf_so_in, *gf_so_out;


/*
 * setup to use and return a pointer to the generic
 * getc function
 */
void
gf_set_readc(gc, txt, len, src)
    gf_io_t       *gc;
    void          *txt;
    unsigned long  len;
    SourceType     src;
{
    gf_in.n = len;
    if(src == FileStar){
	gf_in.file = (FILE *)txt;
	fseek(gf_in.file, 0L, 0);
	*gc = gf_freadc;
    }
    else{
	gf_in.txtp = (char *)txt;
	*gc = gf_sreadc;
    }
}


/*
 * setup to use and return a pointer to the generic
 * putc function
 */
void
gf_set_writec(pc, txt, len, src)
    gf_io_t       *pc;
    void          *txt;
    unsigned long  len;
    SourceType     src;
{
    gf_out.n = len;
    if(src == FileStar){
	gf_out.file = (FILE *)txt;
	*pc = gf_fwritec;
    }
    else{
	gf_out.txtp = (char *)txt;
	*pc = gf_swritec;
    }
}


/*
 * setup to use and return a pointer to the generic
 * getc function
 */
void
gf_set_so_readc(gc, so)
    gf_io_t *gc;
    STORE_S *so;
{
    GF_SO_STACK *sp = (GF_SO_STACK *) fs_get(sizeof(GF_SO_STACK));

    sp->so   = so;
    sp->next = gf_so_in;
    gf_so_in = sp;
    *gc      = gf_so_readc;
}


void
gf_clear_so_readc(so)
    STORE_S *so;
{
    GF_SO_STACK *sp;

    if(sp = gf_so_in){
	if(so == sp->so){
	    gf_so_in = gf_so_in->next;
	    fs_give((void **) &sp);
	}
	else
	  panic("Programmer botch: Can't unstack store readc");
    }
    else
      panic("Programmer botch: NULL store clearing store readc");
}


/*
 * setup to use and return a pointer to the generic
 * putc function
 */
void
gf_set_so_writec(pc, so)
    gf_io_t *pc;
    STORE_S *so;
{
    GF_SO_STACK *sp = (GF_SO_STACK *) fs_get(sizeof(GF_SO_STACK));

    sp->so    = so;
    sp->next  = gf_so_out;
    gf_so_out = sp;
    *pc       = gf_so_writec;
}


void
gf_clear_so_writec(so)
    STORE_S *so;
{
    GF_SO_STACK *sp;

    if(sp = gf_so_out){
	if(so == sp->so){
	    gf_so_out = gf_so_out->next;
	    fs_give((void **) &sp);
	}
	else
	  panic("Programmer botch: Can't unstack store writec");
    }
    else
      panic("Programmer botch: NULL store clearing store writec");
}


/*
 * put the character to the object previously defined
 */
int
gf_so_writec(c)
int c;
{
    return(so_writec(c, gf_so_out->so));
}


/*
 * get a character from an object previously defined
 */
int
gf_so_readc(c)
unsigned char *c;
{
    return(so_readc(c, gf_so_in->so));
}


/* get a character from a file */
/* assumes gf_out struct is filled in */
int
gf_freadc(c)
unsigned char *c;
{
    int rv = 0;

    do {
	errno = 0;
	clearerr(gf_in.file);
	rv = fread(c, sizeof(unsigned char), (size_t)1, gf_in.file);
    } while(!rv && ferror(gf_in.file) && errno == EINTR);

    return(rv);
}


/* put a character to a file */
/* assumes gf_out struct is filled in */
int
gf_fwritec(c)
    int c;
{
    unsigned char ch = (unsigned char)c;
    int rv = 0;

    do
      rv = fwrite(&ch, sizeof(unsigned char), (size_t)1, gf_out.file);
    while(!rv && ferror(gf_out.file) && errno == EINTR);

    return(rv);
}


/* get a character from a string, return nonzero if things OK */
/* assumes gf_out struct is filled in */
int
gf_sreadc(c)
unsigned char *c;
{
    return((gf_in.n) ? *c = *(gf_in.txtp)++, gf_in.n-- : 0);
}


/* put a character into a string, return nonzero if things OK */
/* assumes gf_out struct is filled in */
int
gf_swritec(c)
    int c;
{
    return((gf_out.n) ? *(gf_out.txtp)++ = c, gf_out.n-- : 0);
}


/*
 * output the given string with the given function
 */
int
gf_puts(s, pc)
    register char *s;
    gf_io_t        pc;
{
    while(*s != '\0')
      if(!(*pc)((unsigned char)*s++))
	return(0);		/* ERROR putting char ! */

    return(1);
}


/*
 * output the given string with the given function
 */
int
gf_nputs(s, n, pc)
    register char *s;
    long	   n;
    gf_io_t        pc;
{
    while(n--)
      if(!(*pc)((unsigned char)*s++))
	return(0);		/* ERROR putting char ! */

    return(1);
}


/*
 * Start of generalized filter routines
 */

/*
 * initializing function to make sure list of filters is empty.
 */
void
gf_filter_init()
{
    FILTER_S *flt, *fltn = gf_master;

    while((flt = fltn) != NULL){	/* free list of old filters */
	fltn = flt->next;
	fs_give((void **)&flt);
    }

    gf_master = NULL;
    gf_error_string = NULL;		/* clear previous errors */
    gf_byte_count = 0L;			/* reset counter */
}



/*
 * link the given filter into the filter chain
 */
void
gf_link_filter(f, data)
    filter_t  f;
    void     *data;
{
    FILTER_S *new, *tail;

#ifdef	CRLF_NEWLINES
    /*
     * If the system's native EOL convention is CRLF, then there's no
     * point in passing data thru a filter that's not doing anything
     */
    if(f == gf_nvtnl_local || f == gf_local_nvtnl)
      return;
#endif

    new = (FILTER_S *)fs_get(sizeof(FILTER_S));
    memset(new, 0, sizeof(FILTER_S));

    new->f = f;				/* set the function pointer     */
    new->opt = data;			/* set any optional parameter data */
    (*f)(new, GF_RESET);		/* have it setup initial state  */

    if(tail = gf_master){		/* or add it to end of existing  */
	while(tail->next)		/* list  */
	  tail = tail->next;

	tail->next = new;
    }
    else				/* attach new struct to list    */
      gf_master = new;			/* start a new list */
}


/*
 * terminal filter, doesn't call any other filters, typically just does
 * something with the output
 */
void
gf_terminal(f, flg)
    FILTER_S *f;
    int       flg;
{
    if(flg == GF_DATA){
	GF_INIT(f, f);

	while(op < eob)
	  if((*last_filter)(*op++) <= 0) /* generic terminal filter */
	    gf_error(errno ? error_description(errno) : "Error writing pipe");

	GF_CH_RESET(f);
    }
    else if(flg == GF_RESET)
      errno = 0;			/* prepare for problems */
}


/*
 * set some outside gf_io_t function to the terminal function
 * for example: a function to write a char to a file or into a buffer
 */
void
gf_set_terminal(f)			/* function to set generic filter */
    gf_io_t f;
{
    last_filter = f;
}


/*
 * common function for filter's to make it known that an error
 * has occurred.  Jumps back to gf_pipe with error message.
 */
void
gf_error(s)
    char *s;
{
    /* let the user know the error passed in s */
    gf_error_string = s;
    longjmp(gf_error_state, 1);
}


/*
 * The routine that shoves each byte through the chain of
 * filters.  It sets up error handling, and the terminal function.
 * Then loops getting bytes with the given function, and passing
 * it on to the first filter in the chain.
 */
char *
gf_pipe(gc, pc)
    gf_io_t gc, pc;			/* how to get a character */
{
    unsigned char c;

#if	defined(DOS) && !defined(_WINDOWS)
    MoveCursor(0, 1);
    StartInverse();
#endif

    dprint(4, (debugfile, "-- gf_pipe: "));

    /*
     * set up for any errors a filter may encounter
     */
    if(setjmp(gf_error_state)){
#if	defined(DOS) && !defined(_WINDOWS)
	ibmputc(' ');
	EndInverse();
#endif
	dprint(4, (debugfile, "ERROR: %s\n",
		   gf_error_string ? gf_error_string : "NULL"));
	return(gf_error_string); 	/*  */
    }

    /*
     * set and link in the terminal filter
     */
    gf_set_terminal(pc);
    gf_link_filter(gf_terminal, NULL);

    /*
     * while there are chars to process, send them thru the pipe.
     * NOTE: it's necessary to enclose the loop below in a block
     * as the GF_INIT macro calls some automatic var's into
     * existence.  It can't be placed at the start of gf_pipe
     * because its useful for us to be called without filters loaded
     * when we're just being used to copy bytes between storage
     * objects.
     */
    {
	GF_INIT(gf_master, gf_master);

	while((*gc)(&c)){
	    gf_byte_count++;
#ifdef	DOS
	    if(!(gf_byte_count & 0x3ff))
#ifdef	_WINDOWS
	      /* Under windows we yeild to allow event processing.
	       * Progress display is handled throught the alarm()
	       * mechinism.
	       */
	      mswin_yeild ();
#else
	      /* Poor PC still needs spinning bar */
	      ibmputc("/-\\|"[((int) gf_byte_count >> 10) % 4]);
	      MoveCursor(0, 1);
#endif
#endif

	    GF_PUTC(gf_master, c & 0xff);
	}

	/*
	 * toss an end-of-data marker down the pipe to give filters
	 * that have any buffered data the opportunity to dump it
	 */
	GF_FLUSH(gf_master);
	(*gf_master->f)(gf_master, GF_EOD);
    }

#if	defined(DOS) && !defined(_WINDOWS)
    ibmputc(' ');
    EndInverse();
#endif

    dprint(1, (debugfile, "done.\n"));
    return(NULL);			/* everything went OK */
}


/*
 * return the number of bytes piped so far
 */
long
gf_bytes_piped()
{
    return(gf_byte_count);
}


/*
 * filter the given input with the given command
 *
 *  Args: cmd -- command string to execute
 *	prepend -- string to prepend to filtered input
 *	source_so -- storage object containing data to be filtered
 *	pc -- function to write filtered output with
 *	aux_filters -- additional filters to pass data thru after "cmd"
 *
 *  Returns: NULL on sucess, reason for failure (not alloc'd!) on error
 */
char *
gf_filter(cmd, prepend, source_so, pc, aux_filters)
    char       *cmd, *prepend;
    STORE_S    *source_so;
    gf_io_t	pc;
    FILTLIST_S *aux_filters;
{
    unsigned char c;
    int	     flags;
    char   *errstr = NULL, buf[MAILTMPLEN], *rfile = NULL;
    PIPE_S *fpipe;

    dprint(4, (debugfile, "so_filter: \"%s\"\n", cmd));

    gf_filter_init();
    for( ; aux_filters && aux_filters->filter; aux_filters++)
      gf_link_filter(aux_filters->filter, aux_filters->data);

    gf_set_terminal(pc);
    gf_link_filter(gf_terminal, NULL);

    /*
     * Spawn filter feeding it data, and reading what it writes.
     */
    so_seek(source_so, 0L, 0);
#ifdef	NO_PIPE
    /*
     * When there're no pipes for IPC, use an output file to collect
     * the result...
     */
    flags = PIPE_WRITE | PIPE_NOSHELL | PIPE_RESET;
    rfile = temp_nam(NULL, "pf");
#else
    flags = PIPE_WRITE | PIPE_READ | PIPE_NOSHELL | PIPE_RESET;
#endif

    if(fpipe = open_system_pipe(cmd, rfile ? &rfile : NULL, NULL, flags, 0)){
#ifdef	NO_PIPE
	if(prepend && (fputs(prepend, fpipe->out.f) == EOF
		       || fputc('\n', fpipe->out.f) == EOF))
	  errstr = error_description(errno);

	/*
	 * Write the output, and deal with the result later...
	 */
	while(!errstr && so_readc(&c, source_so))
	  if(fputc(c, fpipe->out.f) == EOF)
	    errstr = error_description(errno);
#else
#ifdef	NON_BLOCKING_IO
	int     n;

	if(fcntl(fileno(fpipe->in.f), F_SETFL, NON_BLOCKING_IO) == -1)
	  errstr = "Can't set up non-blocking IO";

	if(prepend && (fputs(prepend, fpipe->out.f) == EOF
		       || fputc('\n', fpipe->out.f) == EOF))
	  errstr = error_description(errno);

	while(!errstr){
	    /* if the pipe can't hold a K we're sunk (too bad PIPE_MAX
	     * isn't ubiquitous ;).
	     */
	    for(n = 0; !errstr && fpipe->out.f && n < 1024; n++)
	      if(!so_readc(&c, source_so)){
		  fclose(fpipe->out.f);
		  fpipe->out.f = NULL;
	      }
	      else if(fputc(c, fpipe->out.f) == EOF)
		errstr = error_description(errno);

	    /*
	     * Note: We clear errno here and test below, before ferror,
	     *	     because *some* stdio implementations consider
	     *	     EAGAIN and EWOULDBLOCK equivalent to EOF...
	     */
	    errno = 0;
	    clearerr(fpipe->in.f); /* fix from <cananian@cananian.mit.edu> */

	    while(!errstr && fgets(buf, MAILTMPLEN, fpipe->in.f))
	      errstr = gf_filter_puts(buf);

	    /* then fgets failed! */
	    if(!errstr && !(errno == EAGAIN || errno == EWOULDBLOCK)){
		if(feof(fpipe->in.f))		/* nothing else interesting! */
		  break;
		else if(ferror(fpipe->in.f))	/* bummer. */
		  errstr = error_description(errno);
	    }
	    else if(errno == EAGAIN || errno == EWOULDBLOCK)
	      clearerr(fpipe->in.f);
	}
#else
	if(prepend && (fputs(prepend, fpipe->out.f) == EOF
		       || fputc('\n', fpipe->out.f) == EOF))
	  errstr = error_description(errno);

	/*
	 * Well, do the best we can, and hope the pipe we're writing
	 * doesn't fill up before we start reading...
	 */
	while(!errstr && so_readc(&c, source_so))
	  if(fputc(c, fpipe->out.f) == EOF)
	    errstr = error_description(errno);

	fclose(fpipe->out.f);
	fpipe->out.f = NULL;
	while(!errstr && fgets(buf, MAILTMPLEN, fpipe->in.f))
	  errstr = gf_filter_puts(buf);
#endif /* NON_BLOCKING */
#endif /* NO_PIPE */

	gf_filter_eod();

	if(close_system_pipe(&fpipe) && !errstr)
	  errstr = "Pipe command returned error.";

#ifdef	NO_PIPE
	/*
	 * retrieve filters result...
	 */
	{
	    FILE *fp;

	    if(fp = fopen(rfile, STDIO_READ)){
		while(!errstr && fgets(buf, MAILTMPLEN, fp))
		  errstr = gf_filter_puts(buf);

		fclose(fp);
	    }

	    fs_give((void **)&rfile);
	}
#endif
    }

    return(errstr);
}


/*
 * gf_filter_puts - write the given string down the filter's pipe
 */
char *
gf_filter_puts(s)
    register char *s;
{
    GF_INIT(gf_master, gf_master);

    /*
     * set up for any errors a filter may encounter
     */
    if(setjmp(gf_error_state)){
	dprint(4, (debugfile, "ERROR: gf_filter_puts: %s\n",
		   gf_error_string ? gf_error_string : "NULL"));
	return(gf_error_string);
    }

    while(*s)
      GF_PUTC(gf_master, (*s++) & 0xff);

    GF_END(gf_master, gf_master);
    return(NULL);
}


/*
 * gf_filter_eod - flush pending data filter's input queue and deliver
 *		   the GF_EOD marker.
 */
void
gf_filter_eod()
{
    GF_INIT(gf_master, gf_master);
    GF_FLUSH(gf_master);
    (*gf_master->f)(gf_master, GF_EOD);
}




/*
 * END OF PIPE SUPPORT ROUTINES, BEGINNING OF FILTERS
 *
 * Filters MUST use the specified interface (pointer to filter
 * structure, the unsigned character buffer in that struct, and a
 * cmd flag), and pass each resulting octet to the next filter in the
 * chain.  Only the terminal filter need not call another filter.
 * As a result, filters share a pretty general structure.
 * Typically three main conditionals separate initialization from
 * data from end-of-data command processing.
 *
 * Lastly, being character-at-a-time, they're a little more complex
 * to write than filters operating on buffers because some state
 * must typically be kept between characters.  However, for a
 * little bit of complexity here, much convenience is gained later
 * as they can be arbitrarily chained together at run time and
 * consume few resources (especially memory or disk) as they work.
 * (NOTE 951005: even less cpu now that data between filters is passed
 *  via a vector.)
 *
 * A few notes about implementing filters:
 *
 *  - A generic filter template looks like:
 *
 *    void
 *    gf_xxx_filter(f, flg)
 *        FILTER_S *f;
 *        int       flg;
 *    {
 *	  GF_INIT(f, f->next);		// def's var's to speed queue drain
 *
 *        if(flg == GF_DATA){
 *	      register unsigned char c;
 *
 *	      while(GF_GETC(f, c)){	// macro taking data off input queue
 *	          // operate on c and pass it on here
 *                GF_PUTC(f->next, c);	// macro writing output queue
 *	      }
 *
 *	      GF_END(f, f->next);	// macro to sync pointers/offsets
 *	      //WARNING: DO NOT RETURN BEFORE ALL INCOMING DATA'S PROCESSED
 *        }
 *        else if(flg == GF_EOD){
 *            // process any buffered data here and pass it on
 *	      GF_FLUSH(f->next);	// flush pending data to next filter
 *            (*f->next->f)(f->next, GF_EOD);
 *        }
 *        else if(flg == GF_RESET){
 *            // initialize any data in the struct here
 *        }
 *    }
 *
 *  - Any free storage allocated during initialization (typically tied
 *    to the "line" pointer in FILTER_S) is the filter's responsibility
 *    to clean up when the GF_EOD command comes through.
 *
 *  - Filter's must pass GF_EOD they receive on to the next
 *    filter in the chain so it has the opportunity to flush
 *    any buffered data.
 *
 *  - All filters expect NVT end-of-lines.  The idea is to prepend
 *    or append either the gf_local_nvtnl or gf_nvtnl_local
 *    os-dependant filters to the data on the appropriate end of the
 *    pipe for the task at hand.
 *
 *  - NOTE: As of 951004, filters no longer take their input as a single
 *    char argument, but rather get data to operate on via a vector
 *    representing the input queue in the FILTER_S structure.
 *
 */



/*
 * BASE64 TO BINARY encoding and decoding routines below
 */


/*
 * BINARY to BASE64 filter (encoding described in rfc1341)
 */
void
gf_binary_b64(f, flg)
    FILTER_S *f;
    int       flg;
{
    static char *v =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register unsigned char t = f->t;
	register long n = f->n;

	while(GF_GETC(f, c)){

	    switch(n++){
	      case 0 : case 3 : case 6 : case 9 : case 12: case 15: case 18:
	      case 21: case 24: case 27: case 30: case 33: case 36: case 39:
	      case 42: case 45:
		GF_PUTC(f->next, v[c >> 2]);
					/* byte 1: high 6 bits (1) */
		t = c << 4;		/* remember high 2 bits for next */
		break;

	      case 1 : case 4 : case 7 : case 10: case 13: case 16: case 19:
	      case 22: case 25: case 28: case 31: case 34: case 37: case 40:
	      case 43:
		GF_PUTC(f->next, v[(t|(c>>4)) & 0x3f]);
		t = c << 2;
		break;

	      case 2 : case 5 : case 8 : case 11: case 14: case 17: case 20:
	      case 23: case 26: case 29: case 32: case 35: case 38: case 41:
	      case 44:
		GF_PUTC(f->next, v[(t|(c >> 6)) & 0x3f]);
		GF_PUTC(f->next, v[c & 0x3f]);
		break;
	    }

	    if(n == 45){			/* start a new line? */
		GF_PUTC(f->next, '\015');
		GF_PUTC(f->next, '\012');
		n = 0L;
	    }
	}

	f->n = n;
	f->t = t;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){		/* no more data */
	switch (f->n % 3) {		/* handle trailing bytes */
	  case 0:			/* no trailing bytes */
	    break;

	  case 1:
	    GF_PUTC(f->next, v[(f->t) & 0x3f]);
	    GF_PUTC(f->next, '=');	/* byte 3 */
	    GF_PUTC(f->next, '=');	/* byte 4 */
	    break;

	  case 2:
	    GF_PUTC(f->next, v[(f->t) & 0x3f]);
	    GF_PUTC(f->next, '=');	/* byte 4 */
	    break;
	}

	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset binary_b64\n"));
	f->n = 0L;
    }
}



/*
 * BASE64 to BINARY filter (encoding described in rfc1341)
 */
void
gf_b64_binary(f, flg)
    FILTER_S *f;
    int       flg;
{
    static char v[] = {65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,
		       65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,
		       65,65,65,65,65,65,65,65,65,65,65,62,65,65,65,63,
		       52,53,54,55,56,57,58,59,60,61,62,65,65,64,65,65,
		       65, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
		       15,16,17,18,19,20,21,22,23,24,25,65,65,65,65,65,
		       65,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
		       41,42,43,44,45,46,47,48,49,50,51,65,65,65,65,65};
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register unsigned char t = f->t;
	register int n = (int) f->n;
	register int state = f->f1;

	while(GF_GETC(f, c)){

	    if(state){
		state = 0;
		if (c != '=') {
		    gf_error("Illegal '=' in base64 text");
		    /* NO RETURN */
		}
	    }

	    /* in range, and a valid value? */
	    if((c & ~0x7f) || (c = v[c]) > 63){
		if(c == 64){
		    switch (n++) {	/* check quantum position */
		      case 2:
			state++;	/* expect an equal as next char */
			break;

		      case 3:
			n = 0L;		/* restart quantum */
			break;

		      default:		/* impossible quantum position */
			gf_error("Internal base64 decoder error");
			/* NO RETURN */
		    }
		}
	    }
	    else{
		switch (n++) {		/* install based on quantum position */
		  case 0:		/* byte 1: high 6 bits */
		    t = c << 2;
		    break;

		  case 1:		/* byte 1: low 2 bits */
		    GF_PUTC(f->next, (t|(c >> 4)));
		    t = c << 4;		/* byte 2: high 4 bits */
		    break;

		  case 2:		/* byte 2: low 4 bits */
		    GF_PUTC(f->next, (t|(c >> 2)));
		    t = c << 6;		/* byte 3: high 2 bits */
		    break;

		  case 3:
		    GF_PUTC(f->next, t | c);
		    n = 0L;		/* reinitialize mechanism */
		    break;
		}
	    }
	}

	f->f1 = state;
	f->t = t;
	f->n = n;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset b64_binary\n"));
	f->n  = 0L;			/* quantum position */
	f->f1 = 0;			/* state holder: equal seen? */
    }
}




/*
 * QUOTED-PRINTABLE ENCODING AND DECODING filters below.
 * encoding described in rfc1341
 */

#define	GF_MAXLINE	80		/* good buffer size */

/*
 * default action for QUOTED-PRINTABLE to 8BIT decoder
 */
#define	GF_QP_DEFAULT(f, c)	{ \
				    if((c) == ' '){ \
					state = WSPACE; \
						/* reset white space! */ \
					(f)->linep = (f)->line; \
					*((f)->linep)++ = ' '; \
				    } \
				    else if((c) == '='){ \
					state = EQUAL; \
				    } \
				    else \
				      GF_PUTC((f)->next, (c)); \
				}


/*
 * QUOTED-PRINTABLE to 8BIT filter
 */
void
gf_qp_8bit(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;

	while(GF_GETC(f, c)){

	    switch(state){
	      case DFL :		/* default case */
	      default:
		GF_QP_DEFAULT(f, c);
		break;

	      case CCR    :		/* non-significant space */
		state = DFL;
		if(c == '\012')
		  continue;		/* go on to next char */

		GF_QP_DEFAULT(f, c);
		break;

	      case EQUAL  :
		if(c == '\015'){	/* "=\015" is a soft EOL */
		    state = CCR;
		    break;
		}

		if(c == '='){		/* compatibility clause for old guys */
		    GF_PUTC(f->next, '=');
		    state = DFL;
		    break;
		}

		if(!isxdigit((unsigned char)c)){	/* must be hex! */
		    fs_give((void **)&(f->line));
		    gf_error("Non-hexadecimal character in QP encoding");
		    /* NO RETURN */
		}

		if (isdigit ((unsigned char)c))
		  f->t = c - '0';
		else
		  f->t = c - (isupper((unsigned char)c) ? 'A' - 10 : 'a' - 10);

		state = HEX;
		break;

	      case HEX :
		state = DFL;
		if(!isxdigit((unsigned char)c)){	/* must be hex! */
		    fs_give((void **)&(f->line));
		    gf_error("Non-hexadecimal character in QP encoding");
		    /* NO RETURN */
		}

		if (isdigit((unsigned char)c))
		  c -= '0';
		else
		  c -= (isupper((unsigned char)c) ? 'A' - 10 : 'a' - 10);

		GF_PUTC(f->next, c + (f->t << 4));
		break;

	      case WSPACE :
		if(c == ' '){		/* toss it in with other spaces */
		    if(f->linep - f->line < GF_MAXLINE)
		      *(f->linep)++ = ' ';
		    break;
		}

		state = DFL;
		if(c == '\015'){	/* not our white space! */
		    f->linep = f->line;	/* reset buffer */
		    GF_PUTC(f->next, '\015');
		    break;
		}

		/* the spaces are ours, write 'em */
		f->n = f->linep - f->line;
		while((f->n)--)
		  GF_PUTC(f->next, ' ');

		GF_QP_DEFAULT(f, c);	/* take care of 'c' in default way */
		break;
	    }
	}

	f->f1 = state;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	fs_give((void **)&(f->line));
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset qp_8bit\n"));
	f->f1 = DFL;
	f->linep = f->line = (char *)fs_get(GF_MAXLINE * sizeof(char));
    }
}



/*
 * USEFUL MACROS TO HELP WITH QP ENCODING
 */

#define	QP_MAXL	75			/* 76th place only for continuation */

/*
 * Macro to test and wrap long quoted printable lines
 */
#define	GF_8BIT_WRAP(f)		{ \
				    GF_PUTC((f)->next, '='); \
				    GF_PUTC((f)->next, '\015'); \
				    GF_PUTC((f)->next, '\012'); \
				}

/*
 * write a quoted octet in QUOTED-PRINTABLE encoding, adding soft
 * line break if needed.
 */
#define	GF_8BIT_PUT_QUOTE(f, c)	{ \
				    if(((f)->n += 3) > QP_MAXL){ \
					GF_8BIT_WRAP(f); \
					(f)->n = 3;	/* set line count */ \
				    } \
				    GF_PUTC((f)->next, '='); \
				     GF_PUTC((f)->next, HEX_CHAR1(c)); \
				     GF_PUTC((f)->next, HEX_CHAR2(c)); \
				 }

/*
 * just write an ordinary octet in QUOTED-PRINTABLE, wrapping line
 * if needed.
 */
#define	GF_8BIT_PUT(f, c)	{ \
				      if((++(f->n)) > QP_MAXL){ \
					  GF_8BIT_WRAP(f); \
					  f->n = 1L; \
				      } \
				      if(f->n == 1L && c == '.'){ \
					  GF_8BIT_PUT_QUOTE(f, c); \
					  f->n = 3; \
				      } \
				      else \
					GF_PUTC(f->next, c); \
				 }


/*
 * default action for 8bit to quoted printable encoder
 */
#define	GF_8BIT_DEFAULT(f, c)	if((c) == ' '){ \
				     state = WSPACE; \
				 } \
				 else if(c == '\015'){ \
				     state = CCR; \
				 } \
				 else if(iscntrl(c & 0x7f) || (c == 0x7f) \
					 || (c & 0x80) || (c == '=')){ \
				     GF_8BIT_PUT_QUOTE(f, c); \
				 } \
				 else{ \
				   GF_8BIT_PUT(f, c); \
				 }


/*
 * 8BIT to QUOTED-PRINTABLE filter
 */
void
gf_8bit_qp(f, flg)
    FILTER_S *f;
    int       flg;
{
    short dummy_dots = 0, dummy_dmap = 1;
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	 register unsigned char c;
	 register int state = f->f1;

	 while(GF_GETC(f, c)){

	     /* keep track of "^JFrom " */
	     Find_Froms(f->t, dummy_dots, f->f2, dummy_dmap, c);

	     switch(state){
	       case DFL :		/* handle ordinary case */
		 GF_8BIT_DEFAULT(f, c);
		 break;

	       case CCR :		/* true line break? */
		 state = DFL;
		 if(c == '\012'){
		     GF_PUTC(f->next, '\015');
		     GF_PUTC(f->next, '\012');
		     f->n = 0L;
		 }
		 else{			/* nope, quote the CR */
		     GF_8BIT_PUT_QUOTE(f, '\015');
		     GF_8BIT_DEFAULT(f, c); /* and don't forget about c! */
		 }
		 break;

	       case WSPACE:
		 state = DFL;
		 if(c == '\015' || f->t){ /* handle the space */
		     GF_8BIT_PUT_QUOTE(f, ' ');
		     f->t = 0;		/* reset From flag */
		 }
		 else
		   GF_8BIT_PUT(f, ' ');

		 GF_8BIT_DEFAULT(f, c);	/* handle 'c' in the default way */
		 break;
	     }
	 }

	 f->f1 = state;
	 GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	 switch(f->f1){
	   case CCR :
	     GF_8BIT_PUT_QUOTE(f, '\015'); /* write the last cr */
	     break;

	   case WSPACE :
	     GF_8BIT_PUT_QUOTE(f, ' ');	/* write the last space */
	     break;
	 }

	 GF_FLUSH(f->next);
	 (*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	 dprint(9, (debugfile, "-- gf_reset 8bit_qp\n"));
	 f->f1 = DFL;			/* state from last character        */
	 f->f2 = 1;			/* state of "^NFrom " bitmap        */
	 f->t  = 0;
	 f->n  = 0L;			/* number of chars in current line  */
    }
}



/*
 * RICHTEXT-TO-PLAINTEXT filter
 */

/*
 * option to be used by rich2plain (NOTE: if this filter is ever
 * used more than once in a pipe, all instances will have the same
 * option value)
 */


/*----------------------------------------------------------------------
      richtext to plaintext filter

 Args: f --
	flg  --

  This basically removes all richtext formatting. A cute hack is used
  to get bold and underlining to work.
  Further work could be done to handle things like centering and right
  and left flush, but then it could no longer be done in place. This
  operates on text *with* CRLF's.

  WARNING: does not wrap lines!
 ----*/
void
gf_rich2plain(f, flg)
    FILTER_S *f;
    int       flg;
{
/* BUG: qoute incoming \255 values */
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	 register unsigned char c;
	 register int state = f->f1;

	 while(GF_GETC(f, c)){

	     switch(state){
	       case TOKEN :		/* collect a richtext token */
		 if(c == '>'){		/* what should we do with it? */
		     state       = DFL;	/* return to default next time */
		     *(f->linep) = '\0';	/* cap off token */
		     if(f->line[0] == 'l' && f->line[1] == 't'){
			 GF_PUTC(f->next, '<'); /* literal '<' */
		     }
		     else if(f->line[0] == 'n' && f->line[1] == 'l'){
			 GF_PUTC(f->next, '\015');/* newline! */
			 GF_PUTC(f->next, '\012');
		     }
		     else if(!strcmp("comment", f->line)){
			 (f->f2)++;
		     }
		     else if(!strcmp("/comment", f->line)){
			 f->f2 = 0;
		     }
		     else if(!strcmp("/paragraph", f->line)) {
			 GF_PUTC(f->next, '\r');
			 GF_PUTC(f->next, '\n');
			 GF_PUTC(f->next, '\r');
			 GF_PUTC(f->next, '\n');
		     }
		     else if(!f->opt /* gf_rich_plain */){
			 if(!strcmp(f->line, "bold")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_BOLDON);
			 } else if(!strcmp(f->line, "/bold")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_BOLDOFF);
			 } else if(!strcmp(f->line, "italic")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_ULINEON);
			 } else if(!strcmp(f->line, "/italic")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_ULINEOFF);
			 } else if(!strcmp(f->line, "underline")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_ULINEON);
			 } else if(!strcmp(f->line, "/underline")) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, TAG_ULINEOFF);
			 }
		     }
		     /* else we just ignore the token! */

		     f->linep = f->line;	/* reset token buffer */
		 }
		 else{			/* add char to token */
		     if(f->linep - f->line > 40){
			 /* What? rfc1341 says 40 char tokens MAX! */
			 fs_give((void **)&(f->line));
			 gf_error("Richtext token over 40 characters");
			 /* NO RETURN */
		     }

		     *(f->linep)++ = isupper((unsigned char)c) ? c-'A'+'a' : c;
		 }
		 break;

	       case CCR   :
		 state = DFL;		/* back to default next time */
		 if(c == '\012'){	/* treat as single space?    */
		     GF_PUTC(f->next, ' ');
		     break;
		 }
		 /* fall thru to process c */

	       case DFL   :
	       default:
		 if(c == '<')
		   state = TOKEN;
		 else if(c == '\015')
		   state = CCR;
		 else if(!f->f2)		/* not in comment! */
		   GF_PUTC(f->next, c);

		 break;
	     }
	 }

	 f->f1 = state;
	 GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	 if(f->f1 = (f->linep != f->line)){
	     /* incomplete token!! */
	     gf_error("Incomplete token in richtext");
	     /* NO RETURN */
	 }

	 fs_give((void **)&(f->line));
	 GF_FLUSH(f->next);
	 (*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	 dprint(9, (debugfile, "-- gf_reset rich2plain\n"));
	 f->f1 = DFL;			/* state */
	 f->f2 = 0;			/* set means we're in a comment */
	 f->linep = f->line = (char *)fs_get(45 * sizeof(char));
    }
}


/*
 * function called from the outside to set
 * richtext filter's options
 */
void *
gf_rich2plain_opt(plain)
    int plain;
{
    return((void *) plain);
}



/*
 * ENRICHED-TO-PLAIN text filter
 */

#define	TEF_QUELL	0x01
#define	TEF_NOFILL	0x02



/*----------------------------------------------------------------------
      enriched text to plain text filter (ala rfc1523)

 Args: f -- state and input data
	flg --

  This basically removes all enriched formatting. A cute hack is used
  to get bold and underlining to work.

  Further work could be done to handle things like centering and right
  and left flush, but then it could no longer be done in place. This
  operates on text *with* CRLF's.

  WARNING: does not wrap lines!
 ----*/
void
gf_enriched2plain(f, flg)
    FILTER_S *f;
    int       flg;
{
/* BUG: qoute incoming \255 values */
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	 register unsigned char c;
	 register int state = f->f1;

	 while(GF_GETC(f, c)){

	     switch(state){
	       case TOKEN :		/* collect a richtext token */
		 if(c == '>'){		/* what should we do with it? */
		     int   off   = *f->line == '/';
		     char *token = f->line + (off ? 1 : 0);
		     state	= DFL;
		     *f->linep   = '\0';
		     if(!strcmp("param", token)){
			 if(off)
			   f->f2 &= ~TEF_QUELL;
			 else
			   f->f2 |= TEF_QUELL;
		     }
		     else if(!strcmp("nofill", token)){
			 if(off)
			   f->f2 &= ~TEF_NOFILL;
			 else
			   f->f2 |= TEF_NOFILL;
		     }
		     else if(!f->opt /* gf_enriched_plain */){
			 /* Following is a cute hack or two to get
			    bold and underline on the screen.
			    See Putline0n() where these codes are
			    interpreted */
			 if(!strcmp("bold", token)) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, off ? TAG_BOLDOFF : TAG_BOLDON);
			 } else if(!strcmp("italic", token)) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, off ? TAG_ULINEOFF : TAG_ULINEON);
			 } else if(!strcmp("underline", token)) {
			     GF_PUTC(f->next, TAG_EMBED);
			     GF_PUTC(f->next, off ? TAG_ULINEOFF : TAG_ULINEON);
			 }
		     }
		     /* else we just ignore the token! */

		     f->linep = f->line;	/* reset token buffer */
		 }
		 else if(c == '<'){		/* literal '<'? */
		     if(f->linep == f->line){
			 GF_PUTC(f->next, '<');
			 state = DFL;
		     }
		     else{
			 fs_give((void **)&(f->line));
			 gf_error("Malformed Enriched text: unexpected '<'");
			 /* NO RETURN */
		     }
		 }
		 else{			/* add char to token */
		     if(f->linep - f->line > 60){ /* rfc1523 says 60 MAX! */
			 fs_give((void **)&(f->line));
			 gf_error("Malformed Enriched text: token too long");
			 /* NO RETURN */
		     }

		     *(f->linep)++ = isupper((unsigned char)c) ? c-'A'+'a' : c;
		 }
		 break;

	       case CCR   :
		 if(c != '\012'){	/* treat as single space?    */
		     state = DFL;	/* lone cr? */
		     f->f2 &= ~TEF_QUELL;
		     GF_PUTC(f->next, '\015');
		     goto df;
		 }

		 state = CLF;
		 break;

	       case CLF   :
		 if(c == '\015'){	/* treat as single space?    */
		     state = CCR;	/* repeat crlf's mean real newlines */
		     f->f2 |= TEF_QUELL;
		     GF_PUTC(f->next, '\r');
		     GF_PUTC(f->next, '\n');
		     break;
		 }
		 else{
		     state = DFL;
		     if(!((f->f2) & TEF_QUELL))
		       GF_PUTC(f->next, ' ');

		     f->f2 &= ~TEF_QUELL;
		 }

		 /* fall thru to take care of 'c' */

	       case DFL   :
	       default :
	       df :
		 if(c == '<')
		   state = TOKEN;
		 else if(c == '\015' && (!((f->f2) & TEF_NOFILL)))
		   state = CCR;
		 else if(!((f->f2) & TEF_QUELL))
		   GF_PUTC(f->next, c);

		 break;
	     }
	 }

	 f->f1 = state;
	 GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	 if(f->f1 = (f->linep != f->line)){
	     /* incomplete token!! */
	     gf_error("Incomplete token in richtext");
	     /* NO RETURN */
	 }

	 /* Make sure we end with a newline so everything gets flushed */
	 GF_PUTC(f->next, '\015');
	 GF_PUTC(f->next, '\012');

	 fs_give((void **)&(f->line));

	 GF_FLUSH(f->next);
	 (*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	 dprint(9, (debugfile, "-- gf_reset enriched2plain\n"));
	 f->f1 = DFL;			/* state */
	 f->f2 = 0;			/* set means we're in a comment */
	 f->linep = f->line = (char *)fs_get(65 * sizeof(char));
    }
}


/*
 * function called from the outside to set
 * richtext filter's options
 */
void *
gf_enriched2plain_opt(plain)
    int plain;
{
    return((void *) plain);
}



/*
 * HTML-TO-PLAIN text filter
 */


/* OK, here's the plan:

 * a universal output function handles writing  chars and worries
 *    about wrapping.

 * a unversal element collector reads chars and collects params
 * and dispatches the appropriate element handler.

 * element handlers are stacked.  The most recently dispatched gets
 * first crack at the incoming character stream.  It passes bytes it's
 * done with or not interested in to the next

 * installs that handler as the current one collecting data...

 * stacked handlers take their params from the element collector and
 * accept chars or do whatever they need to do.  Sort of a vertical
 * piping? recursion-like? hmmm.

 * at least I think this is how it'll work. tres simple, non?

 */


/*
 * Some important constants
 */
#define	HTML_BUF_LEN	1024		/* max scratch buffer length */
#define	MAX_ENTITY	20		/* maximum length of an entity */
#define	MAX_ELEMENT	72		/* maximum length of an element */
#define	HTML_BADVALUE	0x0100		/* good data, but bad entity value */
#define	HTML_BADDATA	0x0200		/* bad data found looking for entity */
#define	HTML_LITERAL	0x0400		/* Literal character value */
#define	HTML_NEWLINE	0x010A		/* hard newline */
#define	HTML_DOBOLD	0x0400		/* Start Bold display */
#define	HTML_ID_GET	0		/* indent func: return current val */
#define	HTML_ID_SET	1		/* indent func: set to absolute val */
#define	HTML_ID_INC	2		/* indent func: increment by val */
#define	HTML_HX_CENTER	0x0001
#define	HTML_HX_ULINE	0x0002


/*
 * Types used to manage HTML parsing
 */
typedef int (*html_f) PROTO(());

/*
 * Handler data, state information including function that uses it
 */
typedef struct handler_s {
    FILTER_S	     *html_data;
    struct handler_s *below;
    html_f	      f;
    long	      x, y, z;
    unsigned char    *s;
} HANDLER_S;


/*
 * to help manage line wrapping.
 */
typedef	struct _wrap_line {
    char *buf;				/* buf to collect wrapped text */
    int	  used,				/* number of chars in buf */
	   width,			/* text's width as displayed  */
	   len;				/* length of allocated buf */
} WRAPLINE_S;


/*
 * to help manage centered text
 */
typedef	struct _center_s {
    WRAPLINE_S line;			/* buf to assembled centered text */
    WRAPLINE_S word;			/* word being to append to Line */
    int	       anchor;
    short      embedded;
    short      space;
} CENTER_S;


/*
 * Collector data and state information
 */
typedef	struct collector_s {
    char        buf[HTML_BUF_LEN];	/* buffer to collect data */
    int		len;			/* length of that buffer  */
    unsigned    end_tag:1;		/* collecting a closing tag */
    unsigned    hit_equal:1;		/* collecting right half of attrib */
    unsigned	mkup_decl:1;		/* markup declaration */
    unsigned	start_comment:1;	/* markup declaration comment */
    unsigned	end_comment:1;		/* legit comment format */
    unsigned	hyphen:1;		/* markup hyphen read */
    unsigned	badform:1;		/* malformed markup element */
    unsigned	overrun:1;		/* Overran buf above */
    char	quoted;			/* quoted element param value */
    char       *element;		/* element's collected name */
    PARAMETER  *attribs;		/* element's collected attributes */
    PARAMETER  *cur_attrib;		/* attribute now being collected */
} CLCTR_S;


/*
 * State information for all element handlers
 */
typedef struct html_data {
    HANDLER_S  *h_stack;		/* handler list */
    CLCTR_S    *el_data;		/* element collector data */
    CENTER_S   *centered;		/* struct to manage centered text */
    int	      (*token) PROTO((FILTER_S *, int));
    char	quoted;			/* quoted, by either ' or ", text */
    short	indent_level;		/* levels of indention */
    int		in_anchor;		/* text now being written to anchor */
    int		blanks;			/* Consecutive blank line count */
    int		wrapcol;		/* column to wrap lines on */
    int	       *prefix;			/* buffer containing Anchor prefix */
    int		prefix_used;
    COLOR_PAIR *color;
    unsigned	wrapstate:1;		/* whether or not to wrap output */
    unsigned	li_pending:1;		/* <LI> next token expected */
    unsigned	de_pending:1;		/* <DT> or <DD> next token expected */
    unsigned	bold_on:1;		/* currently bolding text */
    unsigned	uline_on:1;		/* currently underlining text */
    unsigned	center:1;		/* center output text */
    unsigned	bitbucket:1;		/* Ignore input */
    unsigned	head:1;			/* In doc's HEAD */
    unsigned	alt_entity:1;		/* use alternative entity values */
} HTML_DATA_S;


/*
 * HTML filter options
 */
typedef	struct _html_opts {
    char      *base;			/* Base URL for this html file */
    int	       columns;			/* Display columns */
    unsigned   strip:1;			/* Hilite TAGs allowed */
    unsigned   handles:1;		/* Anchors as handles requested? */
    unsigned   handles_loc:1;		/* Local handles requested? */
} HTML_OPT_S;


/*
 * Some macros to make life a little easier
 */
#define	WRAP_COLS(X)	((X)->opt ? ((HTML_OPT_S *)(X)->opt)->columns : 80)
#define	HTML_BASE(X)	((X)->opt ? ((HTML_OPT_S *)(X)->opt)->base : NULL)
#define	STRIP(X)	((X)->opt && ((HTML_OPT_S *)(X)->opt)->strip)
#define	HANDLES(X)	((X)->opt && ((HTML_OPT_S *)(X)->opt)->handles)
#define	HANDLES_LOC(X)	((X)->opt && ((HTML_OPT_S *)(X)->opt)->handles_loc)
#define	MAKE_LITERAL(C)	(HTML_LITERAL | ((C) & 0xff))
#define	IS_LITERAL(C)	(HTML_LITERAL & (C))
#define	HD(X)		((HTML_DATA_S *)(X)->data)
#define	ED(X)		(HD(X)->el_data)
#define	HTML_ISSPACE(C)	(IS_LITERAL(C) == 0 && isspace((unsigned char) (C)))
#define	NEW_CLCTR(X)	{						\
			   ED(X) = (CLCTR_S *)fs_get(sizeof(CLCTR_S));  \
			   memset(ED(X), 0, sizeof(CLCTR_S));	\
			   HD(X)->token = html_element_collector;	\
			 }

#define	FREE_CLCTR(X)	{						\
			   if(ED(X)->attribs){				\
			       PARAMETER *p;				\
			       while(p = ED(X)->attribs){		\
				   ED(X)->attribs = ED(X)->attribs->next; \
				   if(p->attribute)			\
				     fs_give((void **)&p->attribute);	\
				   if(p->value)				\
				     fs_give((void **)&p->value);	\
				   fs_give((void **)&p);		\
			       }					\
			   }						\
			   if(ED(X)->element)				\
			     fs_give((void **) &ED(X)->element);	\
			   fs_give((void **) &ED(X));			\
			   HD(X)->token = NULL;				\
			 }
#define	HANDLERS(X)	(HD(X)->h_stack)
#define	BOLD_BIT(X)	(HD(X)->bold_on)
#define	ULINE_BIT(X)	(HD(X)->uline_on)
#define	CENTER_BIT(X)	(HD(X)->center)
#define	HTML_FLUSH(X)	{						    \
			   html_write(X, (X)->line, (X)->linep - (X)->line); \
			   (X)->linep = (X)->line;			    \
			   (X)->f2 = 0L;				    \
			 }
#define	HTML_BOLD(X, S) if(! STRIP(X)){					\
			   if(S){					\
			       html_output((X), TAG_EMBED);		\
			       html_output((X), TAG_BOLDON);		\
			   }						\
			   else if(!(S)){				\
			       html_output((X), TAG_EMBED);		\
			       html_output((X), TAG_BOLDOFF);		\
			   }						\
			 }
#define	HTML_ULINE(X, S)						\
			 if(! STRIP(X)){				\
			   if(S){					\
			       html_output((X), TAG_EMBED);		\
			       html_output((X), TAG_ULINEON);		\
			   }						\
			   else if(!(S)){				\
			       html_output((X), TAG_EMBED);		\
			       html_output((X), TAG_ULINEOFF);		\
			   }						\
			 }
#define WRAPPED_LEN(X)	((HD(f)->centered) \
			    ? (HD(f)->centered->line.width \
				+ HD(f)->centered->word.width \
				+ ((HD(f)->centered->line.width \
				    && HD(f)->centered->word.width) \
				    ? 1 : 0)) \
			    : 0)
#define	HTML_DUMP_LIT(F, S, L)	{					    \
				   int i, c;				    \
				   for(i = 0; i < (L); i++){		    \
				       c = isspace((S)[i])		    \
					     ? (S)[i]			    \
					     : MAKE_LITERAL((S)[i]);	    \
				       HTML_TEXT(F, c);			    \
				   }					    \
				 }
#define	HTML_PROC(F, C) {						    \
			   if(HD(F)->token){				    \
			       int i;					    \
			       if(i = (*(HD(F)->token))(F, C)){		    \
				   if(i < 0){				    \
				       HTML_DUMP_LIT(F, "<", 1);	    \
				       if(HD(F)->el_data->element){	    \
					   HTML_DUMP_LIT(F,		    \
					    HD(F)->el_data->element,	    \
					    strlen(HD(F)->el_data->element));\
				       }				    \
				       if(HD(F)->el_data->len){		    \
					   HTML_DUMP_LIT(F,		    \
						    HD(F)->el_data->buf,    \
						    HD(F)->el_data->len);   \
				       }				    \
				       HTML_TEXT(F, C);			    \
				   }					    \
				   FREE_CLCTR(F);			    \
			       }					    \
			    }						    \
			    else if((C) == '<'){			    \
				NEW_CLCTR(F);				    \
			    }						    \
			    else					    \
			      HTML_TEXT(F, C);				    \
			  }
#define	HTML_TEXT(F, C)	switch((F)->f1){				    \
			     case WSPACE :				    \
			       if(HTML_ISSPACE(C)) /* ignore repeated WS */  \
				 break;					    \
			       HTML_TEXT_OUT(F, ' ');	    \
			       (F)->f1 = DFL;/* stop sending chars here */   \
			       /* fall thru to process 'c' */		    \
			     case DFL:					    \
			       if(HD(F)->bitbucket)			    \
				 (F)->f1 = DFL;	/* no op */		    \
			       else if(HTML_ISSPACE(C) && HD(F)->wrapstate)  \
				 (F)->f1 = WSPACE;/* coalesce white space */ \
			       else HTML_TEXT_OUT(F, C);		    \
			       break;					    \
			 }
#define	HTML_TEXT_OUT(F, C) if(HANDLERS(F)) /* let handlers see C */	    \
			       (*HANDLERS(F)->f)(HANDLERS(F),(C),GF_DATA);   \
			     else					    \
			       html_output(F, C);
#ifdef	DEBUG
#define	HTML_DEBUG_EL(S, D)   {						    \
				 dprint(2, (debugfile, "-- html %s: %s\n",  \
					    S, (D)->element		    \
						 ? (D)->element : "NULL")); \
				 if(debug > 5){				    \
				     PARAMETER *p;			    \
				     for(p = (D)->attribs;		    \
					 p && p->attribute;		    \
					 p = p->next)			    \
				       dprint(6, (debugfile,		    \
						  " PARM: %s%s%s\n",	    \
						  p->attribute		    \
						    ? p->attribute : "NULL",\
						  p->value ? "=" : "",	    \
						  p->value ? p->value : ""));\
				 }					    \
			       }
#else
#define	HTML_DEBUG_EL(S, D)
#endif


/*
 * Protos for Tag handlers
 */
int	html_head PROTO((HANDLER_S *, int, int));
int	html_base PROTO((HANDLER_S *, int, int));
int	html_title PROTO((HANDLER_S *, int, int));
int	html_a PROTO((HANDLER_S *, int, int));
int	html_br PROTO((HANDLER_S *, int, int));
int	html_hr PROTO((HANDLER_S *, int, int));
int	html_p PROTO((HANDLER_S *, int, int));
int	html_tr PROTO((HANDLER_S *, int, int));
int	html_td PROTO((HANDLER_S *, int, int));
int	html_b PROTO((HANDLER_S *, int, int));
int	html_i PROTO((HANDLER_S *, int, int));
int	html_img PROTO((HANDLER_S *, int, int));
int	html_form PROTO((HANDLER_S *, int, int));
int	html_ul PROTO((HANDLER_S *, int, int));
int	html_ol PROTO((HANDLER_S *, int, int));
int	html_menu PROTO((HANDLER_S *, int, int));
int	html_dir PROTO((HANDLER_S *, int, int));
int	html_li PROTO((HANDLER_S *, int, int));
int	html_h1 PROTO((HANDLER_S *, int, int));
int	html_h2 PROTO((HANDLER_S *, int, int));
int	html_h3 PROTO((HANDLER_S *, int, int));
int	html_h4 PROTO((HANDLER_S *, int, int));
int	html_h5 PROTO((HANDLER_S *, int, int));
int	html_h6 PROTO((HANDLER_S *, int, int));
int	html_blockquote PROTO((HANDLER_S *, int, int));
int	html_address PROTO((HANDLER_S *, int, int));
int	html_pre PROTO((HANDLER_S *, int, int));
int	html_center PROTO((HANDLER_S *, int, int));
int	html_div PROTO((HANDLER_S *, int, int));
int	html_dl PROTO((HANDLER_S *, int, int));
int	html_dt PROTO((HANDLER_S *, int, int));
int	html_dd PROTO((HANDLER_S *, int, int));

/*
 * Proto's for support routines
 */
void	html_pop PROTO((FILTER_S *, html_f));
void	html_push PROTO((FILTER_S *, html_f));
int	html_element_collector PROTO((FILTER_S *, int));
int	html_element_flush PROTO((CLCTR_S *));
void	html_element_comment PROTO((FILTER_S *, char *));
void	html_element_output PROTO((FILTER_S *, int));
int	html_entity_collector PROTO((FILTER_S *, int, char **));
void	html_a_prefix PROTO((FILTER_S *));
void	html_a_finish PROTO((HANDLER_S *));
void	html_a_output_prefix PROTO((FILTER_S *, int));
void	html_a_relative PROTO((char *, char *, HANDLE_S *));
int	html_indent PROTO((FILTER_S *, int, int));
void	html_blank PROTO((FILTER_S *, int));
void	html_newline PROTO((FILTER_S *));
void	html_output PROTO((FILTER_S *, int));
void	html_output_flush PROTO((FILTER_S *));
void	html_output_centered PROTO((FILTER_S *, int));
void	html_centered_handle PROTO((int *, char *, int));
void	html_centered_putc PROTO((WRAPLINE_S *, int));
void	html_centered_flush PROTO((FILTER_S *));
void	html_centered_flush_line PROTO((FILTER_S *));
void	html_write_anchor PROTO((FILTER_S *, int));
void	html_write_newline PROTO((FILTER_S *));
void	html_write_indent PROTO((FILTER_S *, int));
void	html_write PROTO((FILTER_S *, char *, int));
void	html_putc PROTO((FILTER_S *, int));


/*
 * Named entity table -- most from HTML 2.0 (rfc1866) plus some from
 *			 W3C doc "Additional named entities for HTML"
 */
static struct html_entities {
    char *name;			/* entity name */
    unsigned char value;	/* entity value */
    char  *plain;		/* plain text representation */
} entity_tab[] = {
    {"quot",	042},		/* Double quote sign */
    {"amp",	046},		/* Ampersand */
    {"bull",	052},		/* Bullet */
    {"ndash",	055},		/* Dash */
    {"mdash",	055},		/* Dash */
    {"lt",	074},		/* Less than sign */
    {"gt",	076},		/* Greater than sign */
    {"nbsp",	0240, " "},	/* no-break space */
    {"iexcl",	0241},		/* inverted exclamation mark */
    {"cent",	0242},		/* cent sign */
    {"pound",	0243},		/* pound sterling sign */
    {"curren",	0244, "CUR"},	/* general currency sign */
    {"yen",	0245},		/* yen sign */
    {"brvbar",	0246, "|"},	/* broken (vertical) bar */
    {"sect",	0247},		/* section sign */
    {"uml",	0250, "\""},		/* umlaut (dieresis) */
    {"copy",	0251, "(C)"},	/* copyright sign */
    {"ordf",	0252, "a"},	/* ordinal indicator, feminine */
    {"laquo",	0253, "<<"},	/* angle quotation mark, left */
    {"not",	0254, "NOT"},	/* not sign */
    {"shy",	0255, "-"},	/* soft hyphen */
    {"reg",	0256, "(R)"},	/* registered sign */
    {"macr",	0257},		/* macron */
    {"deg",	0260, "DEG"},	/* degree sign */
    {"plusmn",	0261, "+/-"},	/* plus-or-minus sign */
    {"sup2",	0262},		/* superscript two */
    {"sup3",	0263},		/* superscript three */
    {"acute",	0264, "'"},	/* acute accent */
    {"micro",	0265},		/* micro sign */
    {"para",	0266},		/* pilcrow (paragraph sign) */
    {"middot",	0267},		/* middle dot */
    {"cedil",	0270},		/* cedilla */
    {"sup1",	0271},		/* superscript one */
    {"ordm",	0272, "o"},	/* ordinal indicator, masculine */
    {"raquo",	0273, ">>"},	/* angle quotation mark, right */
    {"frac14",	0274, " 1/4"},	/* fraction one-quarter */
    {"frac12",	0275, " 1/2"},	/* fraction one-half */
    {"frac34",	0276, " 3/4"},	/* fraction three-quarters */
    {"iquest",	0277},		/* inverted question mark */
    {"Agrave",	0300, "A"},	/* capital A, grave accent */
    {"Aacute",	0301, "A"},	/* capital A, acute accent */
    {"Acirc",	0302, "A"},	/* capital A, circumflex accent */
    {"Atilde",	0303, "A"},	/* capital A, tilde */
    {"Auml",	0304, "AE"},	/* capital A, dieresis or umlaut mark */
    {"Aring",	0305, "A"},	/* capital A, ring */
    {"AElig",	0306, "AE"},	/* capital AE diphthong (ligature) */
    {"Ccedil",	0307, "C"},	/* capital C, cedilla */
    {"Egrave",	0310, "E"},	/* capital E, grave accent */
    {"Eacute",	0311, "E"},	/* capital E, acute accent */
    {"Ecirc",	0312, "E"},	/* capital E, circumflex accent */
    {"Euml",	0313, "E"},	/* capital E, dieresis or umlaut mark */
    {"Igrave",	0314, "I"},	/* capital I, grave accent */
    {"Iacute",	0315, "I"},	/* capital I, acute accent */
    {"Icirc",	0316, "I"},	/* capital I, circumflex accent */
    {"Iuml",	0317, "I"},	/* capital I, dieresis or umlaut mark */
    {"ETH",	0320, "DH"},	/* capital Eth, Icelandic */
    {"Ntilde",	0321, "N"},	/* capital N, tilde */
    {"Ograve",	0322, "O"},	/* capital O, grave accent */
    {"Oacute",	0323, "O"},	/* capital O, acute accent */
    {"Ocirc",	0324, "O"},	/* capital O, circumflex accent */
    {"Otilde",	0325, "O"},	/* capital O, tilde */
    {"Ouml",	0326, "OE"},	/* capital O, dieresis or umlaut mark */
    {"times",	0327, "x"},	/* multiply sign */
    {"Oslash",	0330, "O"},	/* capital O, slash */
    {"Ugrave",	0331, "U"},	/* capital U, grave accent */
    {"Uacute",	0332, "U"},	/* capital U, acute accent */
    {"Ucirc",	0333, "U"},	/* capital U, circumflex accent */
    {"Uuml",	0334, "UE"},	/* capital U, dieresis or umlaut mark */
    {"Yacute",	0335, "Y"},	/* capital Y, acute accent */
    {"THORN",	0336, "P"},	/* capital THORN, Icelandic */
    {"szlig",	0337, "ss"},	/* small sharp s, German (sz ligature) */
    {"agrave",	0340, "a"},	/* small a, grave accent */
    {"aacute",	0341, "a"},	/* small a, acute accent */
    {"acirc",	0342, "a"},	/* small a, circumflex accent */
    {"atilde",	0343, "a"},	/* small a, tilde */
    {"auml",	0344, "ae"},	/* small a, dieresis or umlaut mark */
    {"aring",	0345, "a"},	/* small a, ring */
    {"aelig",	0346, "ae"},	/* small ae diphthong (ligature) */
    {"ccedil",	0347, "c"},	/* small c, cedilla */
    {"egrave",	0350, "e"},	/* small e, grave accent */
    {"eacute",	0351, "e"},	/* small e, acute accent */
    {"ecirc",	0352, "e"},	/* small e, circumflex accent */
    {"euml",	0353, "e"},	/* small e, dieresis or umlaut mark */
    {"igrave",	0354, "i"},	/* small i, grave accent */
    {"iacute",	0355, "i"},	/* small i, acute accent */
    {"icirc",	0356, "i"},	/* small i, circumflex accent */
    {"iuml",	0357, "i"},	/* small i, dieresis or umlaut mark */
    {"eth",	0360, "dh"},	/* small eth, Icelandic */
    {"ntilde",	0361, "n"},	/* small n, tilde */
    {"ograve",	0362, "o"},	/* small o, grave accent */
    {"oacute",	0363, "o"},	/* small o, acute accent */
    {"ocirc",	0364, "o"},	/* small o, circumflex accent */
    {"otilde",	0365, "o"},	/* small o, tilde */
    {"ouml",	0366, "oe"},	/* small o, dieresis or umlaut mark */
    {"divide",	0367, "/"},	/* divide sign */
    {"oslash",	0370, "o"},	/* small o, slash */
    {"ugrave",	0371, "u"},	/* small u, grave accent */
    {"uacute",	0372, "u"},	/* small u, acute accent */
    {"ucirc",	0373, "u"},	/* small u, circumflex accent */
    {"uuml",	0374, "ue"},	/* small u, dieresis or umlaut mark */
    {"yacute",	0375, "y"},	/* small y, acute accent */
    {"thorn",	0376, "p"},	/* small thorn, Icelandic */
    {"yuml",	0377, "y"},	/* small y, dieresis or umlaut mark */
    {NULL,	0}
};


/*
 * Table of supported elements and corresponding handlers
 */
static struct element_table {
    char      *element;
    int	     (*handler) PROTO(());
} element_table[] = {
    {"HTML",		NULL},			/* HTML ignore if seen? */
    {"HEAD",		html_head},		/* slurp until <BODY> ? */
    {"TITLE",		html_title},		/* Document Title */
    {"BASE",		html_base},		/* HREF base */
    {"BODY",		NULL},			/* (NO OP) */
    {"A",		html_a},		/* Anchor */
    {"IMG",		html_img},		/* Image */
    {"HR",		html_hr},		/* Horizontal Rule */
    {"BR",		html_br},		/* Line Break */
    {"P",		html_p},		/* Paragraph */
    {"OL",		html_ol},		/* Ordered List */
    {"UL",		html_ul},		/* Unordered List */
    {"MENU",		html_menu},		/* Menu List */
    {"DIR",		html_dir},		/* Directory List */
    {"LI",		html_li},		/*  ... List Item */
    {"DL",		html_dl},		/* Definition List */
    {"DT",		html_dt},		/*  ... Def. Term */
    {"DD",		html_dd},		/*  ... Def. Definition */
    {"I",		html_i},		/* Italic Text */
    {"EM",		html_i},		/* Typographic Emphasis */
    {"STRONG",		html_i},		/* STRONG Typo Emphasis */
    {"VAR",		html_i},		/* Variable Name */
    {"B",		html_b},		/* Bold Text */
    {"BLOCKQUOTE", 	html_blockquote}, 	/* Blockquote */
    {"ADDRESS",		html_address},		/* Address */
    {"CENTER",		html_center},		/* Centered Text v3.2 */
    {"DIV",		html_div},		/* Document Division 3.2 */
    {"H1",		html_h1},		/* Headings... */
    {"H2",		html_h2},
    {"H3",		html_h3},
    {"H4",		html_h4},
    {"H5",		html_h5},
    {"H6",		html_h6},
    {"PRE",		html_pre},		/* Preformatted Text */
    {"KBD",		NULL},			/* Keyboard Input (NO OP) */
    {"TT",		NULL},			/* Typetype (NO OP) */
    {"SAMP",		NULL},			/* Sample Text (NO OP) */

/*----- Handlers below are NOT DONE OR CHECKED OUT YET -----*/

    {"CITE",		NULL},			/* Citation */
    {"CODE",		NULL},			/* Code Text */

/*----- Handlers below UNIMPLEMENTED (and won't until later) -----*/

    {"FORM",		html_form},		/* form within a document */
    {"INPUT",		NULL},			/* One input field, options */
    {"OPTION",		NULL},			/* One option within Select */
    {"SELECT",		NULL},			/* Selection from a set */
    {"TEXTAREA",	NULL},			/* A multi-line input field */

/*----- Handlers below provide limited support for RFC 1942 Tables -----*/

    {"CAPTION",	html_center},		/* Table Caption */
    {"TR",		html_tr},		/* Table Table Row */
    {"TD",		html_td},		/* Table Table Data */

    {NULL,		NULL}
};



/*
 * Initialize the given handler, and add it to the stack if it
 * requests it.
 */
void
html_push(fd, hf)
    FILTER_S *fd;
    html_f    hf;
{
    HANDLER_S *new;

    new = (HANDLER_S *)fs_get(sizeof(HANDLER_S));
    memset(new, 0, sizeof(HANDLER_S));
    new->html_data = fd;
    new->f	   = hf;
    if((*hf)(new, 0, GF_RESET)){	/* stack the handler? */
	 new->below   = HANDLERS(fd);
	 HANDLERS(fd) = new;		/* push */
    }
    else
      fs_give((void **) &new);
}


/*
 * Remove the most recently installed the given handler
 * after letting it accept its demise.
 */
void
html_pop(fd, hf)
    FILTER_S *fd;
    html_f    hf;
{
    HANDLER_S *tp;

    for(tp = HANDLERS(fd); tp && hf != tp->f; tp = tp->below)
      ;

    if(tp){
	(*tp->f)(tp, 0, GF_EOD);	/* may adjust handler list */
	if(tp != HANDLERS(fd)){
	    HANDLER_S *p;

	    for(p = HANDLERS(fd); p->below != tp; p = p->below)
	      ;

	    if(p)
	      p->below = tp->below;	/* remove from middle of stack */
	    /* BUG: else programming botch and we should die */
	}
	else
	  HANDLERS(fd) = tp->below;	/* pop */

	fs_give((void **)&tp);
    }
    else if(hf == html_p || hf == html_li || hf == html_dt || hf == html_dd){
	/*
	 * Possible "special case" tag handling here.
	 * It's for such tags as Paragraph (`</P>'), List Item
	 * (`</LI>'), Definition Term (`</DT>'), and Definition Description
	 * (`</DD>') elements, which may be omitted...
	 */
	HANDLER_S hd;

	memset(&hd, 0, sizeof(HANDLER_S));
	hd.html_data = fd;
	hd.f	     = hf;

	(*hf)(&hd, 0, GF_EOD);
    }
    /* BUG: else, we should bitch */
}


/*
 * Deal with data passed a hander in its GF_DATA state
 */
html_handoff(hd, ch)
    HANDLER_S *hd;
    int	       ch;
{
    if(hd->below)
      (*hd->below->f)(hd->below, ch, GF_DATA);
    else
      html_output(hd->html_data, ch);
}


/*
 * HTML <BR> element handler
 */
int
html_br(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET)
      html_output(hd->html_data, HTML_NEWLINE);

    return(0);				/* don't get linked */
}


/*
 * HTML <HR> (Horizontal Rule) element handler
 */
int
html_hr(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	int	   i, old_wrap, width, align;
	PARAMETER *p;

	width = WRAP_COLS(hd->html_data);
	align = 0;
	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(p->value){
	      if(!strucmp(p->attribute, "ALIGN")){
		  if(!strucmp(p->value, "LEFT"))
		    align = 1;
		  else if(!strucmp(p->value, "RIGHT"))
		    align = 2;
	      }
	      else if(!strucmp(p->attribute, "WIDTH")){
		  char *cp;

		  width = 0;
		  for(cp = p->value; *cp; cp++)
		    if(*cp == '%'){
			width = (WRAP_COLS(hd->html_data)*min(100,width))/100;
			break;
		    }
		    else if(isdigit((unsigned char) *cp))
		      width = (width * 10) + (*cp - '0');

		  width = min(width, WRAP_COLS(hd->html_data));
	      }
	  }

	html_blank(hd->html_data, 1);	/* at least one blank line */

	old_wrap = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	if((i = max(0, WRAP_COLS(hd->html_data) - width))
	   && ((align == 0) ? i /= 2 : (align == 2)))
	  for(; i > 0; i--)
	    html_output(hd->html_data, ' ');

	for(i = 0; i < width; i++)
	  html_output(hd->html_data, '_');

	html_blank(hd->html_data, 1);
	HD(hd->html_data)->wrapstate = old_wrap;
    }

    return(0);				/* don't get linked */
}


/*
 * HTML <P> (paragraph) element handler
 */
int
html_p(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	/* Make sure there's at least 1 blank line */
	html_blank(hd->html_data, 1);

	/* adjust indent level if needed */
	if(HD(hd->html_data)->li_pending){
	    html_indent(hd->html_data, 4, HTML_ID_INC);
	    HD(hd->html_data)->li_pending = 0;
	}
    }
    else if(cmd == GF_EOD)
      /* Make sure there's at least 1 blank line */
      html_blank(hd->html_data, 1);

    return(0);				/* don't get linked */
}


/*
 * HTML Table <TR> (paragraph) table row
 */
int
html_tr(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET || cmd == GF_EOD)
      /* Make sure there's at least 1 blank line */
      html_blank(hd->html_data, 0);

    return(0);				/* don't get linked */
}


/*
 * HTML Table <TD> (paragraph) table data
 */
int
html_td(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	PARAMETER *p;

	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(!strucmp(p->attribute, "nowrap")
	     && (hd->html_data->f2 || hd->html_data->n)){
	      HTML_DUMP_LIT(hd->html_data, " | ", 3);
	      break;
	  }
    }

    return(0);				/* don't get linked */
}


/*
 * HTML <I> (italic text) element handler
 */
int
html_i(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	/* include LITERAL in spaceness test! */
	if(hd->x && !isspace((unsigned char) (ch & 0xff))){
	    HTML_ULINE(hd->html_data, 1);
	    hd->x = 0;
	}

	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	hd->x = 1;
    }
    else if(cmd == GF_EOD){
	if(!hd->x)
	  HTML_ULINE(hd->html_data, 0);
    }

    return(1);				/* get linked */
}


/*
 * HTML <b> (Bold text) element handler
 */
int
html_b(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	/* include LITERAL in spaceness test! */
	if(hd->x && !isspace((unsigned char) (ch & 0xff))){
	    HTML_ULINE(hd->html_data, 1);
	    hd->x = 0;
	}

	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	hd->x = 1;
    }
    else if(cmd == GF_EOD){
	if(!hd->x)
	  HTML_ULINE(hd->html_data, 0);
    }

    return(1);				/* get linked */
}


/*
 * HTML <IMG> element handler
 */
int
html_img(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	PARAMETER *p;
	char	  *s = NULL;

	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(!strucmp(p->attribute, "alt")){
	      if(p->value && p->value[0]){
		  HTML_DUMP_LIT(hd->html_data, p->value, strlen(p->value));
		  HTML_TEXT(hd->html_data, ' ');
	      }

	      return(0);
	  }

	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(!strucmp(p->attribute, "src") && p->value)
	    if((s = strrindex(p->value, '/')) && *++s != '\0'){
		HTML_TEXT(hd->html_data, '[');
		HTML_DUMP_LIT(hd->html_data, s, strlen(s));
		HTML_TEXT(hd->html_data, ']');
		HTML_TEXT(hd->html_data, ' ');
		return(0);
	    }

	HTML_DUMP_LIT(hd->html_data, "[IMAGE] ", 7);
    }

    return(0);				/* don't get linked */
}


/*
 * HTML <FORM> (Form) element handler
 */
int
html_form(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	char *p;

	html_blank(hd->html_data, 0);

	HTML_DUMP_LIT(hd->html_data, "[FORM]", 6);

	html_blank(hd->html_data, 0);
    }

    return(0);				/* don't get linked */
}


/*
 * HTML <HEAD> element handler
 */
int
html_head(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	HD(hd->html_data)->head = 1;
    }
    else if(cmd == GF_EOD){
	HD(hd->html_data)->head = 0;
    }

    return(1);				/* get linked */
}


/*
 * HTML <BASE> element handler
 */
int
html_base(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	if(HD(hd->html_data)->head && !HTML_BASE(hd->html_data)){
	    PARAMETER *p;

	    for(p = HD(hd->html_data)->el_data->attribs;
		p && p->attribute && strucmp(p->attribute, "HREF");
		p = p->next)
	      ;

	    if(p && p->value && !((HTML_OPT_S *)(hd->html_data)->opt)->base)
	      ((HTML_OPT_S *)(hd->html_data)->opt)->base = cpystr(p->value);
	}
    }

    return(0);				/* DON'T get linked */
}


/*
 * HTML <TITLE> element handler
 */
int
html_title(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	if(hd->x + 1 >= hd->y){
	    hd->y += 80;
	    fs_resize((void **)&hd->s, (size_t)hd->y * sizeof(unsigned char));
	}

	hd->s[hd->x++] = (unsigned char) ch;
    }
    else if(cmd == GF_RESET){
	hd->x = 0L;
	hd->y = 80L;
	hd->s = (unsigned char *)fs_get((size_t)hd->y * sizeof(unsigned char));
    }
    else if(cmd == GF_EOD){
	/* Down the road we probably want to give these bytes to
	 * someone...
	 */
	hd->s[hd->x] = '\0';
	fs_give((void **)&hd->s);
    }

    return(1);				/* get linked */
}


/*
 * HTML <A> (Anchor) element handler
 */
int
html_a(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	int	   i, n, x;
	char	   buf[256];
	HANDLE_S  *h;
	PARAMETER *p, *href = NULL, *name = NULL;

	/*
	 * Pending Anchor!?!?
	 * space insertion/line breaking that's yet to get done...
	 */
	if(HD(hd->html_data)->prefix){
	    dprint(1, (debugfile, "-- html_a: NESTED/UNTERMINATED ANCHOR!\n"));
	    html_a_finish(hd);
	}

	/*
	 * Look for valid Anchor data vis the filter installer's parms
	 * (e.g., Only allow references to our internal URLs if asked)
	 */
	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(!strucmp(p->attribute, "HREF")
	     && p->value
	     && (HANDLES_LOC(hd->html_data)
		 || struncmp(p->value, "x-pine-", 7)))
	    href = p;
	  else if(!strucmp(p->attribute, "NAME"))
	    name = p;

	if(HANDLES(hd->html_data) && (href || name)){
	    h = new_handle();

	    /*
	     * Enhancement: we might want to get fancier and parse the
	     * href a bit further such that we can launch images using
	     * our image viewer, or browse local files or directories
	     * with our internal tools.  Of course, having the jump-off
	     * point into text/html always be the defined "web-browser",
	     * just might be the least confusing UI-wise...
	     */
	    h->type = URL;

	    if(name && name->value)
	      h->h.url.name = cpystr(name->value);

	    /*
	     * Prepare to build embedded prefix...
	     */
	    HD(hd->html_data)->prefix = (int *) fs_get(64 * sizeof(int));
	    x = 0;

	    /*
	     * Is this something that looks like a URL?  If not and
	     * we were giving some "base" string, proceed ala RFC1808...
	     */
	    if(href){
		if(HTML_BASE(hd->html_data) && !rfc1738_scan(href->value, &n))
		  html_a_relative(HTML_BASE(hd->html_data), href->value, h);
		else
		  h->h.url.path = cpystr(href->value);

		if(pico_usingcolor()){
		    char *fg = NULL, *bg = NULL, *q;

		    if(ps_global->VAR_SLCTBL_FORE_COLOR
		       && colorcmp(ps_global->VAR_SLCTBL_FORE_COLOR,
				   ps_global->VAR_NORM_FORE_COLOR))
		      fg = ps_global->VAR_SLCTBL_FORE_COLOR;

		    if(ps_global->VAR_SLCTBL_BACK_COLOR
		       && colorcmp(ps_global->VAR_SLCTBL_BACK_COLOR,
				   ps_global->VAR_NORM_BACK_COLOR))
		      bg = ps_global->VAR_SLCTBL_BACK_COLOR;

		    if(fg || bg){
			COLOR_PAIR *tmp;

			/*
			 * The blacks are just known good colors for testing
			 * whether the other color is good.
			 */
			tmp = new_color_pair(fg ? fg : colorx(COL_BLACK),
					     bg ? bg : colorx(COL_BLACK));
			if(pico_is_good_colorpair(tmp)){
			    q = color_embed(fg, bg);

			    for(i = 0; q[i]; i++)
			      HD(hd->html_data)->prefix[x++] = q[i];
			}

			if(tmp)
			  free_color_pair(&tmp);
		    }

		    if(F_OFF(F_SLCTBL_ITEM_NOBOLD, ps_global))
		      HD(hd->html_data)->prefix[x++] = HTML_DOBOLD;
		}
		else
		  HD(hd->html_data)->prefix[x++] = HTML_DOBOLD;
	    }

	    HD(hd->html_data)->prefix[x++] = TAG_EMBED;
	    HD(hd->html_data)->prefix[x++] = TAG_HANDLE;

	    sprintf(buf, "%d", h->key);
	    HD(hd->html_data)->prefix[x++] = n = strlen(buf);
	    for(i = 0; i < n; i++)
	      HD(hd->html_data)->prefix[x++] = buf[i];

	    HD(hd->html_data)->prefix_used = x;
	}
    }
    else if(cmd == GF_EOD){
	html_a_finish(hd);
    }

    return(1);				/* get linked */
}


void
html_a_prefix(f)
    FILTER_S *f;
{
    int *prefix, n;

    /* Do this so we don't visit from html_output... */
    prefix = HD(f)->prefix;
    HD(f)->prefix = NULL;

    for(n = 0; n < HD(f)->prefix_used; n++)
      html_a_output_prefix(f, prefix[n]);

    fs_give((void **) &prefix);
}


/*
 * html_a_finish - house keeping associated with end of link tag
 */
void
html_a_finish(hd)
    HANDLER_S *hd;
{
    if(HANDLES(hd->html_data)){
	if(HD(hd->html_data)->prefix)
	  html_a_prefix(hd->html_data);

	if(pico_usingcolor()){
	    char *fg = NULL, *bg = NULL, *p;
	    int   i;

	    if(ps_global->VAR_SLCTBL_FORE_COLOR
	       && colorcmp(ps_global->VAR_SLCTBL_FORE_COLOR,
			   ps_global->VAR_NORM_FORE_COLOR))
	      fg = ps_global->VAR_NORM_FORE_COLOR;

	    if(ps_global->VAR_SLCTBL_BACK_COLOR
	       && colorcmp(ps_global->VAR_SLCTBL_BACK_COLOR,
			   ps_global->VAR_NORM_BACK_COLOR))
	      bg = ps_global->VAR_NORM_BACK_COLOR;

	    if(F_OFF(F_SLCTBL_ITEM_NOBOLD, ps_global))
	      HTML_BOLD(hd->html_data, 0);	/* turn OFF bold */

	    if(fg || bg){
		COLOR_PAIR *tmp;

		/*
		 * The blacks are just known good colors for testing
		 * whether the other color is good.
		 */
		tmp = new_color_pair(fg ? fg : colorx(COL_BLACK),
				     bg ? bg : colorx(COL_BLACK));
		if(pico_is_good_colorpair(tmp)){
		    p = color_embed(fg, bg);

		    for(i = 0; p[i]; i++)
		      html_output(hd->html_data, p[i]);
		}

		if(tmp)
		  free_color_pair(&tmp);
	    }
	}
	else
	  HTML_BOLD(hd->html_data, 0);	/* turn OFF bold */

	html_output(hd->html_data, TAG_EMBED);
	html_output(hd->html_data, TAG_HANDLEOFF);
    }
}


/*
 * html_output_a_prefix - dump Anchor prefix data
 */
void
html_a_output_prefix(f, c)
    FILTER_S *f;
    int	      c;
{
    switch(c){
      case HTML_DOBOLD :
	HTML_BOLD(f, 1);
	break;

      default :
	html_output(f, c);
	break;
    }
}



/*
 * relative_url - put full url path in h based on base and relative url
 */
void
html_a_relative(base_url, rel_url, h)
    char     *base_url, *rel_url;
    HANDLE_S *h;
{
    size_t  len;
    char    tmp[MAILTMPLEN], *p, *q;
    char   *scheme = NULL, *net = NULL, *path = NULL,
	   *parms = NULL, *query = NULL, *frag = NULL,
	   *base_scheme = NULL, *base_net_loc = NULL,
	   *base_path = NULL, *base_parms = NULL,
	   *base_query = NULL, *base_frag = NULL,
	   *rel_scheme = NULL, *rel_net_loc = NULL,
	   *rel_path = NULL, *rel_parms = NULL,
	   *rel_query = NULL, *rel_frag = NULL;

    /* Rough parse of base URL */
    rfc1808_tokens(base_url, &base_scheme, &base_net_loc, &base_path,
		   &base_parms, &base_query, &base_frag);

    /* Rough parse of this URL */
    rfc1808_tokens(rel_url, &rel_scheme, &rel_net_loc, &rel_path,
		   &rel_parms, &rel_query, &rel_frag);

    scheme = rel_scheme;	/* defaults */
    net    = rel_net_loc;
    path   = rel_path;
    parms  = rel_parms;
    query  = rel_query;
    frag   = rel_frag;
    if(!scheme && base_scheme){
	scheme = base_scheme;
	if(!net){
	    net = base_net_loc;
	    if(path){
		if(*path != '/'){
		    if(base_path){
			for(p = q = base_path;	/* Drop base path's tail */
			    p = strchr(p, '/');
			    q = ++p)
			  ;

			len = q - base_path;
		    }
		    else
		      len = 0;

		    if(len + strlen(rel_path) < MAILTMPLEN - 1){
			if(len)
			  sprintf(path = tmp, "%.*s", len, base_path);

			strcpy(tmp + len, rel_path);

			/* Follow RFC 1808 "Step 6" */
			for(p = tmp; p = strchr(p, '.'); )
			  switch(*(p+1)){
			      /*
			       * a) All occurrences of "./", where "." is a
			       *    complete path segment, are removed.
			       */
			    case '/' :
			      if(p > tmp)
				for(q = p; *q = *(q+2); q++)
				  ;
			      else
				p++;

			      break;

			      /*
			       * b) If the path ends with "." as a
			       *    complete path segment, that "." is
			       *    removed.
			       */
			    case '\0' :
			      if(p == tmp || *(p-1) == '/')
				*p = '\0';
			      else
				p++;

			      break;

			      /*
			       * c) All occurrences of "<segment>/../",
			       *    where <segment> is a complete path
			       *    segment not equal to "..", are removed.
			       *    Removal of these path segments is
			       *    performed iteratively, removing the
			       *    leftmost matching pattern on each
			       *    iteration, until no matching pattern
			       *    remains.
			       *
			       * d) If the path ends with "<segment>/..",
			       *    where <segment> is a complete path
			       *    segment not equal to "..", that
			       *    "<segment>/.." is removed.
			       */
			    case '.' :
			      if(p > tmp + 1){
				  for(q = p - 2; q > tmp && *q != '/'; q--)
				    ;

				  if(*q == '/')
				    q++;

				  if(q + 1 == p		/* no "//.." */
				     || (*q == '.'	/* and "../.." */
					 && *(q+1) == '.'
					 && *(q+2) == '/')){
				      p += 2;
				      break;
				  }

				  switch(*(p+2)){
				    case '/' :
				      len = (p - q) + 3;
				      p = q;
				      for(; *q = *(q+len); q++)
					;

				      break;

				    case '\0':
				      *(p = q) = '\0';
				      break;

				    default:
				      p += 2;
				      break;
				  }
			      }
			      else
				p += 2;

			      break;

			    default :
			      p++;
			      break;
			  }
		    }
		    else
		      path = "";		/* lame. */
		}
	    }
	    else{
		path = base_path;
		if(!parms){
		    parms = base_parms;
		    if(!query)
		      query = base_query;
		}
	    }
	}
    }

    len = (scheme ? strlen(scheme) : 0) + (net ? strlen(net) : 0)
	  + (path ? strlen(path) : 0) + (parms ? strlen(parms) : 0)
	  + (query ? strlen(query) : 0) + (frag  ? strlen(frag ) : 0) + 8;

    h->h.url.path = (char *) fs_get(len * sizeof(char));
    sprintf(h->h.url.path, "%s%s%s%s%s%s%s%s%s%s%s%s",
	    scheme ? scheme : "", scheme ? ":" : "",
	    net ? "//" : "", net ? net : "",
	    (path && *path == '/') ? "" : ((path && net) ? "/" : ""),
	    path ? path : "",
	    parms ? ";" : "", parms ? parms : "",
	    query ? "?" : "", query ? query : "",
	    frag ? "#" : "", frag ? frag : "");

    if(base_scheme)
      fs_give((void **) &base_scheme);

    if(base_net_loc)
      fs_give((void **) &base_net_loc);

    if(base_path)
      fs_give((void **) &base_path);

    if(base_parms)
      fs_give((void **) &base_parms);

    if(base_query)
      fs_give((void **) &base_query);

    if(base_frag)
      fs_give((void **) &base_frag);

    if(rel_scheme)
      fs_give((void **) &rel_scheme);

    if(rel_net_loc)
      fs_give((void **) &rel_net_loc);

    if(rel_parms)
      fs_give((void **) &rel_parms);

    if(rel_query)
      fs_give((void **) &rel_query);

    if(rel_frag)
      fs_give((void **) &rel_frag);

    if(rel_path)
      fs_give((void **) &rel_path);
}


/*
 * HTML <UL> (Unordered List) element handler
 */
int
html_ul(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	HD(hd->html_data)->li_pending = 1;
	html_blank(hd->html_data, 0);
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 0);

	if(!HD(hd->html_data)->li_pending)
	  html_indent(hd->html_data, -4, HTML_ID_INC);
	else
	  HD(hd->html_data)->li_pending = 0;
    }

    return(1);				/* get linked */
}


/*
 * HTML <OL> (Ordered List) element handler
 */
int
html_ol(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Signal that we're expecting to see <LI> as our next elemnt
	 * and set the the initial ordered count.
	 */
	HD(hd->html_data)->li_pending = 1;
	hd->x = 1L;
	html_blank(hd->html_data, 0);
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 0);

	if(!HD(hd->html_data)->li_pending)
	  html_indent(hd->html_data, -4, HTML_ID_INC);
	else
	  HD(hd->html_data)->li_pending = 0;
    }

    return(1);				/* get linked */
}


/*
 * HTML <MENU> (Menu List) element handler
 */
int
html_menu(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	HD(hd->html_data)->li_pending = 1;
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 0);

	if(!HD(hd->html_data)->li_pending)
	  html_indent(hd->html_data, -4, HTML_ID_INC);
	else
	  HD(hd->html_data)->li_pending = 0;
    }

    return(1);				/* get linked */
}


/*
 * HTML <DIR> (Directory List) element handler
 */
int
html_dir(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	HD(hd->html_data)->li_pending = 1;
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 0);

	if(!HD(hd->html_data)->li_pending)
	  html_indent(hd->html_data, -4, HTML_ID_INC);
	else
	  HD(hd->html_data)->li_pending = 0;
    }

    return(1);				/* get linked */
}


/*
 * HTML <LI> (List Item) element handler
 */
int
html_li(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	HANDLER_S *p, *found = NULL;

	/*
	 * There better be a an unordered list, ordered list,
	 * Menu or Directory handler installed
	 * or else we crap out...
	 */
	for(p = HANDLERS(hd->html_data); p; p = p->below)
	  if(p->f == html_ul || p->f == html_ol
	     || p->f == html_menu || p->f == html_dir){
	      found = p;
	      break;
	  }

	if(found){
	    char buf[8], *p;
	    int  wrapstate;

	    /* Start a new line */
	    html_blank(hd->html_data, 0);

	    /* adjust indent level if needed */
	    if(HD(hd->html_data)->li_pending){
		html_indent(hd->html_data, 4, HTML_ID_INC);
		HD(hd->html_data)->li_pending = 0;
	    }

	    if(found->f == html_ul){
		int l = html_indent(hd->html_data, 0, HTML_ID_GET);

		strcpy(buf, "   ");
		buf[1] = (l < 5) ? '*' : (l < 9) ? '+' : (l < 17) ? 'o' : '#';
	    }
	    else if(found->f == html_ol)
	      sprintf(buf, "%2ld.", found->x++);
	    else if(found->f == html_menu)
	      strcpy(buf, " ->");

	    html_indent(hd->html_data, -4, HTML_ID_INC);

	    /* So we don't munge whitespace */
	    wrapstate = HD(hd->html_data)->wrapstate;
	    HD(hd->html_data)->wrapstate = 0;

	    html_write_indent(hd->html_data, HD(hd->html_data)->indent_level);
	    for(p = buf; *p; p++)
	      html_output(hd->html_data, (int) *p);

	    HD(hd->html_data)->wrapstate = wrapstate;
	    html_indent(hd->html_data, 4, HTML_ID_INC);
	}
	/* BUG: should really bitch about this */
    }

    return(0);				/* DON'T get linked */
}



/*
 * HTML <DL> (Definition List) element handler
 */
int
html_dl(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Set indention level for definition terms and definitions...
	 */
	hd->x = html_indent(hd->html_data, 0, HTML_ID_GET);
	hd->y = hd->x + 2;
	hd->z = hd->y + 4;
    }
    else if(cmd == GF_EOD){
	html_indent(hd->html_data, (int) hd->x, HTML_ID_SET);
	html_blank(hd->html_data, 1);
    }

    return(1);				/* get linked */
}


/*
 * HTML <DT> (Definition Term) element handler
 */
int
html_dt(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	HANDLER_S *p;

	/*
	 * There better be a Definition Handler installed
	 * or else we crap out...
	 */
	for(p = HANDLERS(hd->html_data); p && p->f != html_dl; p = p->below)
	  ;

	if(p){				/* adjust indent level if needed */
	    html_indent(hd->html_data, (int) p->y, HTML_ID_SET);
	    html_blank(hd->html_data, 1);
	}
	/* BUG: else should really bitch about this */
    }

    return(0);				/* DON'T get linked */
}


/*
 * HTML <DD> (Definition Definition) element handler
 */
int
html_dd(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_RESET){
	HANDLER_S *p;

	/*
	 * There better be a Definition Handler installed
	 * or else we crap out...
	 */
	for(p = HANDLERS(hd->html_data); p && p->f != html_dl; p = p->below)
	  ;

	if(p){				/* adjust indent level if needed */
	    html_indent(hd->html_data, (int) p->z, HTML_ID_SET);
	    html_blank(hd->html_data, 0);
	}
	/* BUG: should really bitch about this */
    }

    return(0);				/* DON'T get linked */
}


/*
 * HTML <H1> (Headings 1) element handler.
 *
 * Bold, very-large font, CENTERED. One or two blank lines
 * above and below.  For our silly character cell's that
 * means centered and ALL CAPS...
 */
int
html_h1(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/* turn ON the centered bit */
	CENTER_BIT(hd->html_data) = 1;
    }
    else if(cmd == GF_EOD){
	/* turn OFF the centered bit, add blank line */
	CENTER_BIT(hd->html_data) = 0;
	html_blank(hd->html_data, 1);
    }

    return(1);				/* get linked */
}


/*
 * HTML <H2> (Headings 2) element handler
 */
int
html_h2(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	if((hd->x & HTML_HX_ULINE) && !isspace((unsigned char) (ch & 0xff))){
	    HTML_ULINE(hd->html_data, 1);
	    hd->x ^= HTML_HX_ULINE;	/* only once! */
	}

	html_handoff(hd, (ch < 128 && islower((unsigned char) ch))
			   ? toupper((unsigned char) ch) : ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Bold, large font, flush-left. One or two blank lines
	 * above and below.
	 */
	if(CENTER_BIT(hd->html_data)) /* stop centering for now */
	  hd->x = HTML_HX_CENTER;
	else
	  hd->x = 0;

	hd->x |= HTML_HX_ULINE;
	    
	CENTER_BIT(hd->html_data) = 0;
	hd->y = html_indent(hd->html_data, 0, HTML_ID_SET);
	hd->z = HD(hd->html_data)->wrapcol;
	HD(hd->html_data)->wrapcol = WRAP_COLS(hd->html_data) - 8;
	html_blank(hd->html_data, 1);
    }
    else if(cmd == GF_EOD){
	/*
	 * restore previous centering, and indent level
	 */
	if(!(hd->x & HTML_HX_ULINE))
	  HTML_ULINE(hd->html_data, 0);

	html_indent(hd->html_data, hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 1);
	CENTER_BIT(hd->html_data)  = (hd->x & HTML_HX_CENTER) != 0;
	HD(hd->html_data)->wrapcol = hd->z;
    }

    return(1);				/* get linked */
}


/*
 * HTML <H3> (Headings 3) element handler
 */
int
html_h3(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	if((hd->x & HTML_HX_ULINE) && !isspace((unsigned char) (ch & 0xff))){
	    HTML_ULINE(hd->html_data, 1);
	    hd->x ^= HTML_HX_ULINE;	/* only once! */
	}

	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Italic, large font, slightly indented from the left
	 * margin. One or two blank lines above and below.
	 */
	if(CENTER_BIT(hd->html_data)) /* stop centering for now */
	  hd->x = HTML_HX_CENTER;
	else
	  hd->x = 0;

	hd->x |= HTML_HX_ULINE;
	CENTER_BIT(hd->html_data) = 0;
	hd->y = html_indent(hd->html_data, 2, HTML_ID_SET);
	hd->z = HD(hd->html_data)->wrapcol;
	HD(hd->html_data)->wrapcol = WRAP_COLS(hd->html_data) - 8;
	html_blank(hd->html_data, 1);
    }
    else if(cmd == GF_EOD){
	/*
	 * restore previous centering, and indent level
	 */
	if(!(hd->x & HTML_HX_ULINE))
	  HTML_ULINE(hd->html_data, 0);

	html_indent(hd->html_data, hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 1);
	CENTER_BIT(hd->html_data)  = (hd->x & HTML_HX_CENTER) != 0;
	HD(hd->html_data)->wrapcol = hd->z;
    }

    return(1);				/* get linked */
}


/*
 * HTML <H4> (Headings 4) element handler
 */
int
html_h4(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Bold, normal font, indented more than H3. One blank line
	 * above and below.
	 */
	hd->x = CENTER_BIT(hd->html_data); /* stop centering for now */
	CENTER_BIT(hd->html_data) = 0;
	hd->y = html_indent(hd->html_data, 4, HTML_ID_SET);
	hd->z = HD(hd->html_data)->wrapcol;
	HD(hd->html_data)->wrapcol = WRAP_COLS(hd->html_data) - 8;
	html_blank(hd->html_data, 1);
    }
    else if(cmd == GF_EOD){
	/*
	 * restore previous centering, and indent level
	 */
	html_indent(hd->html_data, (int) hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 1);
	CENTER_BIT(hd->html_data)  = hd->x;
	HD(hd->html_data)->wrapcol = hd->z;
    }

    return(1);				/* get linked */
}


/*
 * HTML <H5> (Headings 5) element handler
 */
int
html_h5(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Italic, normal font, indented as H4. One blank line
	 * above.
	 */
	hd->x = CENTER_BIT(hd->html_data); /* stop centering for now */
	CENTER_BIT(hd->html_data) = 0;
	hd->y = html_indent(hd->html_data, 6, HTML_ID_SET);
	hd->z = HD(hd->html_data)->wrapcol;
	HD(hd->html_data)->wrapcol = WRAP_COLS(hd->html_data) - 8;
	html_blank(hd->html_data, 1);
    }
    else if(cmd == GF_EOD){
	/*
	 * restore previous centering, and indent level
	 */
	html_indent(hd->html_data, (int) hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 1);
	CENTER_BIT(hd->html_data)  = hd->x;
	HD(hd->html_data)->wrapcol = hd->z;
    }

    return(1);				/* get linked */
}


/*
 * HTML <H6> (Headings 6) element handler
 */
int
html_h6(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * Bold, indented same as normal text, more than H5. One
	 * blank line above.
	 */
	hd->x = CENTER_BIT(hd->html_data); /* stop centering for now */
	CENTER_BIT(hd->html_data) = 0;
	hd->y = html_indent(hd->html_data, 8, HTML_ID_SET);
	hd->z = HD(hd->html_data)->wrapcol;
	HD(hd->html_data)->wrapcol = WRAP_COLS(hd->html_data) - 8;
	html_blank(hd->html_data, 1);
    }
    else if(cmd == GF_EOD){
	/*
	 * restore previous centering, and indent level
	 */
	html_indent(hd->html_data, (int) hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 1);
	CENTER_BIT(hd->html_data)  = hd->x;
	HD(hd->html_data)->wrapcol = hd->z;
    }

    return(1);				/* get linked */
}


/*
 * HTML <BlockQuote> element handler
 */
int
html_blockquote(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    int	 j;
#define	HTML_BQ_INDENT	6

    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * A typical rendering might be a slight extra left and
	 * right indent, and/or italic font. The Blockquote element
	 * causes a paragraph break, and typically provides space
	 * above and below the quote.
	 */
	html_indent(hd->html_data, HTML_BQ_INDENT, HTML_ID_INC);
	j = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	html_blank(hd->html_data, 1);
	HD(hd->html_data)->wrapstate = j;
	HD(hd->html_data)->wrapcol  -= HTML_BQ_INDENT;
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 1);

	j = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	html_indent(hd->html_data, -(HTML_BQ_INDENT), HTML_ID_INC);
	HD(hd->html_data)->wrapstate = j;
	HD(hd->html_data)->wrapcol  += HTML_BQ_INDENT;
    }

    return(1);				/* get linked */
}


/*
 * HTML <Address> element handler
 */
int
html_address(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    int	 j;
#define	HTML_ADD_INDENT	2

    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/*
	 * A typical rendering might be a slight extra left and
	 * right indent, and/or italic font. The Blockquote element
	 * causes a paragraph break, and typically provides space
	 * above and below the quote.
	 */
	html_indent(hd->html_data, HTML_ADD_INDENT, HTML_ID_INC);
	j = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	html_blank(hd->html_data, 1);
	HD(hd->html_data)->wrapstate = j;
    }
    else if(cmd == GF_EOD){
	html_blank(hd->html_data, 1);

	j = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	html_indent(hd->html_data, -(HTML_ADD_INDENT), HTML_ID_INC);
	HD(hd->html_data)->wrapstate = j;
    }

    return(1);				/* get linked */
}


/*
 * HTML <PRE> (Preformatted Text) element handler
 */
int
html_pre(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	/*
	 * remove CRLF after '>' in element.
	 * We see CRLF because wrapstate is off.
	 */
	switch(hd->y){
	  case 2 :
	    if(ch == '\012'){
		hd->y = 3;
		return(1);
	    }
	    else
	      html_handoff(hd, '\015');

	    break;

	  case 1 :
	    if(ch == '\015'){
		hd->y = 2;
		return(1);
	    }

	  default :
	    hd->y = 0;
	    break;
	}

	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	html_blank(hd->html_data, 1);
	hd->x = HD(hd->html_data)->wrapstate;
	HD(hd->html_data)->wrapstate = 0;
	hd->y = 1;
    }
    else if(cmd == GF_EOD){
	HD(hd->html_data)->wrapstate = (hd->x != 0);
	html_blank(hd->html_data, 0);
    }

    return(1);
}




/*
 * HTML <CENTER> (Centerd Text) element handler
 */
int
html_center(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	/* turn ON the centered bit */
	CENTER_BIT(hd->html_data) = 1;
    }
    else if(cmd == GF_EOD){
	/* turn OFF the centered bit */
	CENTER_BIT(hd->html_data) = 0;
    }

    return(1);
}



/*
 * HTML <DIV> (Document Divisions) element handler
 */
int
html_div(hd, ch, cmd)
    HANDLER_S *hd;
    int	       ch, cmd;
{
    if(cmd == GF_DATA){
	html_handoff(hd, ch);
    }
    else if(cmd == GF_RESET){
	PARAMETER *p;

	for(p = HD(hd->html_data)->el_data->attribs;
	    p && p->attribute;
	    p = p->next)
	  if(!strucmp(p->attribute, "ALIGN")){
	      if(p->value){
		  /* remember previous values */
		  hd->x = CENTER_BIT(hd->html_data);
		  hd->y = html_indent(hd->html_data, 0, HTML_ID_GET);

		  html_blank(hd->html_data, 0);
		  CENTER_BIT(hd->html_data) = !strucmp(p->value, "CENTER");
		  html_indent(hd->html_data, 0, HTML_ID_SET);
		  /* NOTE: "RIGHT" not supported yet */
	      }
	  }
    }
    else if(cmd == GF_EOD){
	/* restore centered bit and indentiousness */
	CENTER_BIT(hd->html_data) = hd->y;
	html_indent(hd->html_data, hd->y, HTML_ID_SET);
	html_blank(hd->html_data, 0);
    }

    return(1);
}



/*
 * return the function associated with the given element name
 */
html_f
html_element_func(el_name)
    char *el_name;
{
    register int i;

    for(i = 0; element_table[i].element; i++)
      if(!strucmp(el_name, element_table[i].element))
	return(element_table[i].handler);

    return(NULL);
}


/*
 * collect element's name and any attribute/value pairs then
 * dispatch to the appropriate handler.
 *
 * Returns 1 : got what we wanted
 *	   0 : we need more data
 *	  -1 : bogus input
 */
int
html_element_collector(fd, ch)
    FILTER_S *fd;
    int	      ch;
{
    if(ch == '>'){
	if(ED(fd)->overrun){
	    /*
	     * If problem processing, don't bother doing anything
	     * internally, just return such that none of what we've
	     * digested is displayed.
	     */
	    HTML_DEBUG_EL("too long", ED(fd));
	    return(1);			/* Let it go, Jim */
	}
	else if(ED(fd)->mkup_decl){
	    if(ED(fd)->badform){
		dprint(2, (debugfile, "-- html <!-- BAD: %.*s\n",
			   ED(fd)->len, ED(fd)->buf));
		/*
		 * Invalid comment -- make some guesses as
		 * to whether we should stop with this greater-than...
		 */
		if(ED(fd)->buf[0] != '-'
		   || ED(fd)->len < 4
		   || (ED(fd)->buf[1] == '-'
		       && ED(fd)->buf[ED(fd)->len - 1] == '-'
		       && ED(fd)->buf[ED(fd)->len - 2] == '-'))
		  return(1);
	    }
	    else{
		dprint(2, (debugfile, "-- html <!-- OK: %.*s\n",
			   ED(fd)->len, ED(fd)->buf));
		if(ED(fd)->start_comment == ED(fd)->end_comment){
		    if(ED(fd)->len > 10){
			ED(fd)->buf[ED(fd)->len - 2] = '\0';
			html_element_comment(fd, ED(fd)->buf + 2);
		    }

		    return(1);
		}
		/* else keep collecting comment below */
	    }
	}
	else if(!ED(fd)->quoted || ED(fd)->badform){
	    html_f f;

	    /*
	     * We either have the whole thing or all that we could
	     * salvage from it.  Try our best...
	     */

	    if(HD(fd)->bitbucket)
	      return(1);		/* element inside chtml clause! */

	    if(!ED(fd)->badform && html_element_flush(ED(fd)))
	      return(1);		/* return without display... */

	    /*
	     * If we ran into an empty tag or we don't know how to deal
	     * with it, just go on, ignoring it...
	     */
	    if(ED(fd)->element && (f = html_element_func(ED(fd)->element))){
		/* dispatch the element's handler */
		if(ED(fd)->end_tag)
		  html_pop(fd, f);	/* remove it's handler */
		else
		  html_push(fd, f);	/* add it's handler */

		HTML_DEBUG_EL(ED(fd)->end_tag ? "POP" : "PUSH", ED(fd));
	    }
	    else{			/* else, empty or unrecognized */
		HTML_DEBUG_EL("?", ED(fd));
	    }

	    return(1);			/* all done! see, that didn't hurt */
	}
    }

    if(ED(fd)->mkup_decl){
	if((ch &= 0xff) == '-'){
	    if(ED(fd)->hyphen){
		ED(fd)->hyphen = 0;
		if(ED(fd)->start_comment)
		  ED(fd)->end_comment = 1;
		else
		  ED(fd)->start_comment = 1;
	    }
	    else
	      ED(fd)->hyphen = 1;
	}
	else{
	    if(ED(fd)->end_comment)
	      ED(fd)->start_comment = ED(fd)->end_comment = 0;

	    /*
	     * no "--" after ! or non-whitespace between comments - bad
	     */
	    if(ED(fd)->len < 2 || (!ED(fd)->start_comment
				   && !isspace((unsigned char) ch)))
	      ED(fd)->badform = 1;	/* non-comment! */

	    ED(fd)->hyphen = 0;
	}

	/*
	 * Remember the comment for possible later processing, if
	 * it get's too long, remember first and last few chars
	 * so we know when to terminate (and throw some garbage
	 * in between when we toss out what's between.
	 */
	if(ED(fd)->len == HTML_BUF_LEN){
	    ED(fd)->buf[2] = ED(fd)->buf[3] = 'X';
	    ED(fd)->buf[4] = ED(fd)->buf[ED(fd)->len - 2];
	    ED(fd)->buf[5] = ED(fd)->buf[ED(fd)->len - 1];
	    ED(fd)->len    = 6;
	}

	ED(fd)->buf[(ED(fd)->len)++] = ch;
	return(0);			/* comments go in the bit bucket */
    }
    else if(ED(fd)->overrun || ED(fd)->badform){
	return(0);			/* swallow char's until next '>' */
    }
    else if(!ED(fd)->element && !ED(fd)->len){
	if(ch == '/'){		/* validate leading chars */
	    ED(fd)->end_tag = 1;
	    return(0);
	}
	else if(ch == '!'){
	    ED(fd)->mkup_decl = 1;
	    return(0);
	}
	else if(!isalpha((unsigned char) ch))
	  return(-1);			/* can't be a tag! */
    }
    else if(ch == '\"' || ch == '\''){
	if(!ED(fd)->hit_equal){
	    ED(fd)->badform = 1;	/* quote in element name?!? */
	    return(0);
	}

	if(ED(fd)->quoted){
	    if(ED(fd)->quoted == (char) ch){
		ED(fd)->quoted = 0;
		return(0);		/* continue collecting chars */
	    }
	    /* else fall thru writing other quoting char */
	}
	else{
	    ED(fd)->quoted = (char) ch;
	    return(0);			/* need more data */
	}
    }

    ch &= 0xff;			/* strip any "literal" high bits */
    if(ED(fd)->quoted
       || isalnum(ch)
       || strchr("-.!", ch)
       || (ED(fd)->hit_equal && !isspace((unsigned char) ch))){
	if(ED(fd)->len < ((ED(fd)->element || !ED(fd)->hit_equal)
			       ? HTML_BUF_LEN:MAX_ELEMENT)){
	    ED(fd)->buf[(ED(fd)->len)++] = ch;
	}
	else
	  ED(fd)->overrun = 1;		/* flag it broken */
    }
    else if(isspace((unsigned char) ch) || ch == '='){
	if(html_element_flush(ED(fd))){
	    ED(fd)->badform = 1;
	    return(0);		/* else, we ain't done yet */
	}

	if(!ED(fd)->hit_equal)
	  ED(fd)->hit_equal = (ch == '=');
    }
    else
      ED(fd)->badform = 1;		/* unrecognized data?? */

    return(0);				/* keep collecting */
}


/*
 * Element collector found complete string, integrate it and reset
 * internal collection buffer.
 *
 * Returns zero if element collection buffer flushed, error flag otherwise
 */
int
html_element_flush(el_data)
    CLCTR_S *el_data;
{
    int rv = 0;

    if(el_data->hit_equal){		/* adding a value */
	el_data->hit_equal = 0;
	if(el_data->cur_attrib){
	    if(!el_data->cur_attrib->value){
		el_data->cur_attrib->value = cpystr(el_data->len
						    ? el_data->buf : "");
	    }
	    else{
		dprint(2, (debugfile,
			   "** element: unexpected value: %.10s...\n",
			   el_data->len ? el_data->buf : "\"\""));
		rv = 1;
	    }
	}
	else{
	    dprint(2, (debugfile,
		       "** element: missing attribute name: %.10s...\n",
		       el_data->len ? el_data->buf : "\"\""));
	    rv = 2;
	}

	el_data->len = 0;
	memset(el_data->buf, 0, HTML_BUF_LEN);
    }
    else if(el_data->len){
	if(!el_data->element){
	    el_data->element = cpystr(el_data->buf);
	}
	else{
	    PARAMETER *p = (PARAMETER *)fs_get(sizeof(PARAMETER));
	    memset(p, 0, sizeof(PARAMETER));
	    if(el_data->attribs){
		el_data->cur_attrib->next = p;
		el_data->cur_attrib = p;
	    }
	    else
	      el_data->attribs = el_data->cur_attrib = p;

	    p->attribute = cpystr(el_data->buf);
	}

	el_data->len = 0;
	memset(el_data->buf, 0, HTML_BUF_LEN);
    }

    return(rv);			/* report whatever happened above */
}


/*
 * html_element_comment - "Special" comment handling here
 */
void
html_element_comment(f, s)
    FILTER_S *f;
    char     *s;
{
    char *p;

    while(*s && isspace((unsigned char) *s))
      s++;

    /*
     * WARNING: "!--chtml" denotes "Conditional HTML", a UW-ism.
     */
    if(!struncmp(s, "chtml ", 6)){
	s += 6;
	if(!struncmp(s, "if ", 3)){
	    HD(f)->bitbucket = 1;	/* default is failure! */
	    switch(*(s += 3)){
	      case 'P' :
	      case 'p' :
		if(!struncmp(s + 1, "inemode=", 8)){
		    if(!strucmp(s = removing_quotes(s + 9), "function_key")
		       && F_ON(F_USE_FK, ps_global))
		      HD(f)->bitbucket = 0;
		    else if(!strucmp(s, "running"))
		      HD(f)->bitbucket = 0;
		    else if(!strucmp(s, "phone_home") && ps_global->phone_home)
		      HD(f)->bitbucket = 0;
#ifdef	_WINDOWS
		    else if(!strucmp(s, "os_windows"))
		      HD(f)->bitbucket = 0;
#endif
		}

		break;

	      case '[' :	/* test */
		if(p = strindex(++s, ']')){
		    *p = '\0';		/* tie off test string */
		    removing_leading_white_space(s);
		    removing_trailing_white_space(s);
		    if(*s == '-' && *(s+1) == 'r'){ /* readable file? */
			for(s += 2; *s && isspace((unsigned char) *s); s++)
			  ;


			HD(f)->bitbucket = (can_access(removing_quotes(s),
						       READ_ACCESS) != 0);
		    }
		}

		break;

	      default :
		break;
	    }
	}
	else if(!strucmp(s, "else")){
	    HD(f)->bitbucket = !HD(f)->bitbucket;
	}
	else if(!strucmp(s, "endif")){
	    /* Clean up after chtml here */
	    HD(f)->bitbucket = 0;
	}
    }
    else if(!HD(f)->bitbucket){
	if(!struncmp(s, "#include ", 9)){
	    char  buf[MAILTMPLEN], *bufp;
	    int   len, end_of_line;
	    FILE *fp;

	    /* Include the named file */
	    if(!struncmp(s += 9, "file=", 5)
	       && (fp = fopen(removing_quotes(s+5), "r"))){
		html_element_output(f, HTML_NEWLINE);

		while(fgets(buf, MAILTMPLEN, fp)){
		    if((len = strlen(buf)) && buf[len-1] == '\n'){
			end_of_line = 1;
			buf[--len]  = '\0';
		    }
		    else
		      end_of_line = 0;

		    for(bufp = buf; len; bufp++, len--)
		      html_element_output(f, (int) *bufp);

		    if(end_of_line)
		      html_element_output(f, HTML_NEWLINE);
		}

		fclose(fp);
		html_element_output(f, HTML_NEWLINE);
		HD(f)->blanks = 0;
		if(f->f1 == WSPACE)
		  f->f1 = DFL;
	    }
	}
	else if(!struncmp(s, "#echo ", 6)){
	    if(!struncmp(s += 6, "var=", 4)){
		char	*p, buf[MAILTMPLEN];
		ADDRESS *adr;
		extern char datestamp[];

		if(!strcmp(s = removing_quotes(s + 4), "PINE_VERSION")){
		    p = pine_version;
		}
		else if(!strcmp(s, "PINE_COMPILE_DATE")){
		    p = datestamp;
		}
		else if(!strcmp(s, "PINE_TODAYS_DATE")){
		    rfc822_date(p = buf);
		}
		else if(!strcmp(s, "_LOCAL_FULLNAME_")){
		    p = (ps_global->VAR_LOCAL_FULLNAME
			 && ps_global->VAR_LOCAL_FULLNAME[0])
			    ? ps_global->VAR_LOCAL_FULLNAME
			    : "Local Support";
		}
		else if(!strcmp(s, "_LOCAL_ADDRESS_")){
		    p = (ps_global->VAR_LOCAL_ADDRESS
			 && ps_global->VAR_LOCAL_ADDRESS[0])
			   ? ps_global->VAR_LOCAL_ADDRESS
			   : "postmaster";
		    adr = rfc822_parse_mailbox(&p, ps_global->maildomain);
		    sprintf(p = buf, "%s@%s", adr->mailbox, adr->host);
		    mail_free_address(&adr);
		}
		else if(!strcmp(s, "_BUGS_FULLNAME_")){
		    p = (ps_global->VAR_BUGS_FULLNAME
			 && ps_global->VAR_BUGS_FULLNAME[0])
			    ? ps_global->VAR_BUGS_FULLNAME
			    : "Place to report Pine Bugs";
		}
		else if(!strcmp(s, "_BUGS_ADDRESS_")){
		    p = (ps_global->VAR_BUGS_ADDRESS
			 && ps_global->VAR_BUGS_ADDRESS[0])
			    ? ps_global->VAR_BUGS_ADDRESS : "postmaster";
		    adr = rfc822_parse_mailbox(&p, ps_global->maildomain);
		    sprintf(p = buf, "%s@%s", adr->mailbox, adr->host);
		    mail_free_address(&adr);
		}
		else if(!strcmp(s, "CURRENT_DIR")){
		    getcwd(p = buf, MAILTMPLEN);
		}
		else if(!strcmp(s, "HOME_DIR")){
		    p = ps_global->home_dir;
		}
		else
		  p = NULL;

		if(p){
		    if(f->f1 == WSPACE){
			html_element_output(f, ' ');
			f->f1 = DFL;			/* clear it */
		    }

		    while(*p)
		      html_element_output(f, (int) *p++);
		}
	    }
	}
    }
}


void
html_element_output(f, ch)
    FILTER_S *f;
    int	      ch;
{
    if(HANDLERS(f))
      (*HANDLERS(f)->f)(HANDLERS(f), ch, GF_DATA);
    else
      html_output(f, ch);
}


/*
 * collect html entities and return its value when done.
 *
 * Returns 0		 : we need more data
 *	   1-255	 : char value of entity collected
 *	   HTML_BADVALUE : good data, but no named match or out of range
 *	   HTML_BADDATA  : invalid input
 *
 * NOTES:
 *  - entity format is "'&' tag ';'" and represents a literal char
 *  - named entities are CASE SENSITIVE.
 *  - numeric char references (where the tag is prefixed with a '#')
 *    are a char with that numbers value
 *  - numeric vals are 0-255 except for the ranges: 0-8, 11-31, 127-159.
 */
int
html_entity_collector(f, ch, alternate)
    FILTER_S  *f;
    int	       ch;
    char     **alternate;
{
    static char len = 0;
    static char buf[MAX_ENTITY];
    int rv = 0, i;

    if((len == 0)
	 ? (isalpha((unsigned char) ch) || ch == '#')
	 : ((isdigit((unsigned char) ch)
	     || (isalpha((unsigned char) ch) && buf[0] != '#'))
	    && len < MAX_ENTITY - 1)){
	buf[len++] = ch;
    }
    else if((isspace((unsigned char) ch) || ch == ';') && len){
	buf[len] = '\0';		/* got something! */
	switch(buf[0]){
	  case '#' :
	    rv = atoi(&buf[1]);
	    if(F_ON(F_PASS_CONTROL_CHARS, ps_global)
	       || (rv == '\t' || rv == '\n' || rv == '\r'
		   || (rv > 31 && rv < 127) || (rv > 159 && rv < 256))){
		if(alternate)
		  for(i = 0, *alternate = NULL; entity_tab[i].name; i++)
		    if(entity_tab[i].value == rv){
			*alternate = entity_tab[i].plain;
			break;
		    }
	    }
	    else
	      rv = HTML_BADVALUE;

	    break;

	  default :
	    rv = HTML_BADVALUE;		/* in case we fail below */
	    for(i = 0; entity_tab[i].name; i++)
	      if(strcmp(entity_tab[i].name, buf) == 0){
		  rv = entity_tab[i].value;
		  if(alternate)
		    *alternate = entity_tab[i].plain;

		  break;
	      }

	    break;
	}
    }
    else
      rv = HTML_BADDATA;		/* bogus input! */

    if(rv){				/* nonzero return, clean up */
	if(rv > 0xff && alternate){	/* provide bogus data to caller */
	    buf[len] = '\0';
	    *alternate = buf;
	}

	len = 0;
    }

    return(rv);
}


/*----------------------------------------------------------------------
  HTML text to plain text filter

  This basically tries to do the best it can with HTML 2.0 (RFC1866)
  with bits of RFC 1942 (plus some HTML 3.2 thrown in as well) text
  formatting.

 ----*/
void
gf_html2plain(f, flg)
    FILTER_S *f;
    int       flg;
{
/* BUG: qoute incoming \255 values (see "yuml" above!) */
    if(flg == GF_DATA){
	register int c;
	GF_INIT(f, f->next);

	while(GF_GETC(f, c)){
	    /*
	     * First we have to collect any literal entities...
	     * that is, IF we're not already collecting one
	     * AND we're not in element's text or, if we are, we're
	     * not in quoted text.  Whew.
	     */
	    if(f->t){
		int   i;
		char *alt = NULL;

		switch(i = html_entity_collector(f, c, &alt)){
		  case 0:		/* more data required? */
		    continue;		/* go get another char */

		  case HTML_BADVALUE :
		  case HTML_BADDATA :
		    /* if supplied, process bogus data */
		    HTML_PROC(f, '&');
		    for(; *alt; alt++)
		      HTML_PROC(f, *alt);

		    if(c == '&' && !HD(f)->quoted){
			f->t = '&';
			continue;
		    }
		    else
		      f->t = 0;		/* don't come back next time */

		    break;

		  default :		/* thing to process */
		    f->t = 0;		/* don't come back */

		    /*
		     * Map some of the undisplayable entities?
		     */
		    if(HD(f)->alt_entity && i > 127 && alt && alt[0]){
			for(; *alt; alt++){
			    c = MAKE_LITERAL(*alt);
			    HTML_PROC(f, c);
			}

			continue;
		    }

		    c = MAKE_LITERAL(i);
		    break;
		}
	    }
	    else if(c == '&' && !HD(f)->quoted){
		f->t = '&';
		continue;
	    }

	    /*
	     * then we process whatever we got...
	     */

	    HTML_PROC(f, c);
	}

	GF_OP_END(f);			/* clean up our input pointers */
    }
    else if(flg == GF_EOD){
	while(HANDLERS(f))
	  /* BUG: should complain about "Unexpected end of HTML text." */
	  html_pop(f, HANDLERS(f)->f);

	html_output(f, HTML_NEWLINE);
	HTML_FLUSH(f);
	fs_give((void **)&f->line);
	if(HD(f)->color)
	  free_color_pair(&HD(f)->color);

	fs_give(&f->data);
	if(f->opt){
	    if(((HTML_OPT_S *)f->opt)->base)
	      fs_give((void **) &((HTML_OPT_S *)f->opt)->base);

	    fs_give(&f->opt);
	}

	(*f->next->f)(f->next, GF_DATA);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset html2plain\n"));
	f->data  = (HTML_DATA_S *) fs_get(sizeof(HTML_DATA_S));
	memset(f->data, 0, sizeof(HTML_DATA_S));
	HD(f)->wrapstate = 1;		/* start with flowing text */
	HD(f)->wrapcol   = WRAP_COLS(f) - 8;
	f->f1    = DFL;			/* state */
	f->f2    = 0;			/* chars in wrap buffer */
	f->n     = 0L;			/* chars on line so far */
	f->linep = f->line = (char *)fs_get(HTML_BUF_LEN * sizeof(char));
	HD(f)->alt_entity =  (!ps_global->VAR_CHAR_SET
			      || strucmp(ps_global->VAR_CHAR_SET,
					 "iso-8859-1"));
    }
}



/*
 * html_indent - do the requested indent level function with appropriate
 *		 flushing and such.
 *
 *   Returns: indent level prior to set/increment
 */
int
html_indent(f, val, func)
    FILTER_S *f;
    int	      val, func;
{
    int old = HD(f)->indent_level;

    /* flush pending data at old indent level */
    switch(func){
      case HTML_ID_INC :
	html_output_flush(f);
	if((HD(f)->indent_level += val) < 0)
	  HD(f)->indent_level = 0;

	break;

      case HTML_ID_SET :
	html_output_flush(f);
	HD(f)->indent_level = val;
	break;

      default :
	break;
    }

    return(old);
}



/*
 * html_blanks - Insert n blank lines into output
 */
void
html_blank(f, n)
    FILTER_S *f;
    int	      n;
{
    /* Cap off any flowing text, and then write blank lines */
    if(f->f2 || f->n || CENTER_BIT(f) || HD(f)->centered || WRAPPED_LEN(f))
      html_output(f, HTML_NEWLINE);

    if(HD(f)->wrapstate)
      while(HD(f)->blanks < n)	/* blanks inc'd by HTML_NEWLINE */
	html_output(f, HTML_NEWLINE);
}



/*
 *  html_newline -- insert a newline mindful of embedded tags
 */
void
html_newline(f)
    FILTER_S *f;
{
    html_write_newline(f);		/* commit an actual newline */

    if(f->n){				/* and keep track of blank lines */
	HD(f)->blanks = 0;
	f->n = 0L;
    }
    else
      HD(f)->blanks++;
}


/*
 * output the given char, handling any requested wrapping.
 * It's understood that all whitespace handed us is written.  In other
 * words, junk whitespace is weeded out before it's given to us here.
 *
 */
void
html_output(f, ch)
    FILTER_S *f;
    int	      ch;
{
    if(CENTER_BIT(f)){			/* center incoming text */
	html_output_centered(f, ch);
    }
    else{
	static short embedded = 0; /* BUG: reset on entering filter */
	static char *color_ptr = NULL;

	if(HD(f)->centered){
	    html_centered_flush(f);
	    fs_give((void **) &HD(f)->centered->line.buf);
	    fs_give((void **) &HD(f)->centered->word.buf);
	    fs_give((void **) &HD(f)->centered);
	}

	if(HD(f)->wrapstate){
	    if(ch == HTML_NEWLINE){		/* hard newline */
		html_output_flush(f);
		html_newline(f);
	    }
	    else
	      HD(f)->blanks = 0;		/* reset blank line counter */

	    if(ch == TAG_EMBED){	/* takes up no space */
		embedded = 1;
		*(f->linep)++ = TAG_EMBED;
	    }
	    else if(embedded){	/* ditto */
		if(ch == TAG_HANDLE)
		  embedded = -1;	/* next ch is length */
		else if(ch == TAG_FGCOLOR || ch == TAG_BGCOLOR){
		    if(!HD(f)->color)
		      HD(f)->color = new_color_pair(NULL, NULL);

		    if(ch == TAG_FGCOLOR)
		      color_ptr = HD(f)->color->fg;
		    else
		      color_ptr = HD(f)->color->bg;

		    embedded = 11;
		}
		else if(embedded < 0){
		    embedded = ch;	/* number of embedded chars */
		}
		else{
		    embedded--;
		    if(color_ptr)
		      *color_ptr++ = ch;

		    if(embedded == 0 && color_ptr){
			*color_ptr = '\0';
			color_ptr = NULL;
		    }
		}

		*(f->linep)++ = ch;
	    }
	    else if(HTML_ISSPACE(ch)){
		html_output_flush(f);
	    }
	    else{
		if(HD(f)->prefix)
		  html_a_prefix(f);

		if(++f->f2 >= WRAP_COLS(f)){
		    HTML_FLUSH(f);
		    html_newline(f);
		    if(HD(f)->in_anchor)
		      html_write_anchor(f, HD(f)->in_anchor);
		}
		else
		  *(f->linep)++ = ch & 0xff;
	    }
	}
	else{
	    if(HD(f)->prefix)
	      html_a_prefix(f);

	    html_output_flush(f);

	    switch(embedded){
	      case 0 :
		switch(ch){
		  default :
		    f->n++;			/* inc displayed char count */
		    HD(f)->blanks = 0;		/* reset blank line counter */
		    html_putc(f, ch & 0xff);
		    break;

		  case TAG_EMBED :	/* takes up no space */
		    html_putc(f, TAG_EMBED);
		    embedded = -2;
		    break;

		  case HTML_NEWLINE :		/* newline handling */
		    if(!f->n)
		      break;

		  case '\n' :
		    html_newline(f);

		  case '\r' :
		    break;
		}

		break;

	      case -2 :
		embedded = 0;
		switch(ch){
		  case TAG_HANDLE :
		    embedded = -1;	/* next ch is length */
		    break;

		  case TAG_BOLDON :
		    BOLD_BIT(f) = 1;
		    break;

		  case TAG_BOLDOFF :
		    BOLD_BIT(f) = 0;
		    break;

		  case TAG_ULINEON :
		    ULINE_BIT(f) = 1;
		    break;

		  case TAG_ULINEOFF :
		    ULINE_BIT(f) = 0;
		    break;

		  case TAG_FGCOLOR :
		    if(!HD(f)->color)
		      HD(f)->color = new_color_pair(NULL, NULL);

		    color_ptr = HD(f)->color->fg;
		    embedded = 11;
		    break;

		  case TAG_BGCOLOR :
		    if(!HD(f)->color)
		      HD(f)->color = new_color_pair(NULL, NULL);

		    color_ptr = HD(f)->color->bg;
		    embedded = 11;
		    break;

		  case TAG_HANDLEOFF :
		    ch = TAG_INVOFF;
		    HD(f)->in_anchor = 0;
		    break;

		  default :
		    break;
		}

		html_putc(f, ch);
		break;

	      case -1 :
		embedded = ch;	/* number of embedded chars */
		html_putc(f, ch);
		break;

	      default :
		embedded--;
		if(color_ptr)
		  *color_ptr++ = ch;

		if(embedded == 0 && color_ptr){
		    *color_ptr = '\0';
		    color_ptr = NULL;
		}

		html_putc(f, ch);
		break;
	    }
	}
    }
}


/*
 * flush any buffered chars waiting for wrapping.
 */
void
html_output_flush(f)
    FILTER_S *f;
{
    if(f->f2){
	if(f->n && ((int) f->n) + f->f2 > HD(f)->wrapcol)
	  html_newline(f);		/* wrap? */

	if(f->n){			/* text already on the line? */
	    html_putc(f, ' ');
	    f->n++;			/* increment count */
	}
	else{
	    /* write at start of new line */
	    html_write_indent(f, HD(f)->indent_level);

	    if(HD(f)->in_anchor)
	      html_write_anchor(f, HD(f)->in_anchor);
	}

	f->n += f->f2;
	HTML_FLUSH(f);
    }
}



/*
 * html_output_centered - managed writing centered text
 */
void
html_output_centered(f, ch)
    FILTER_S *f;
    int	      ch;
{
    if(!HD(f)->centered){		/* new text? */
	html_output_flush(f);
	if(f->n)			/* start on blank line */
	  html_newline(f);

	HD(f)->centered = (CENTER_S *) fs_get(sizeof(CENTER_S));
	memset(HD(f)->centered, 0, sizeof(CENTER_S));
	/* and grab a buf to start collecting centered text */
	HD(f)->centered->line.len  = WRAP_COLS(f);
	HD(f)->centered->line.buf  = (char *) fs_get(HD(f)->centered->line.len
							      * sizeof(char));
	HD(f)->centered->line.used = HD(f)->centered->line.width = 0;
	HD(f)->centered->word.len  = 32;
	HD(f)->centered->word.buf  = (char *) fs_get(HD(f)->centered->word.len
							       * sizeof(char));
	HD(f)->centered->word.used = HD(f)->centered->word.width = 0;
    }

    if(ch == HTML_NEWLINE){		/* hard newline */
	html_centered_flush(f);
    }
    else if(ch == TAG_EMBED){		/* takes up no space */
	HD(f)->centered->embedded = 1;
	html_centered_putc(&HD(f)->centered->word, TAG_EMBED);
    }
    else if(HD(f)->centered->embedded){
	static char *color_ptr = NULL;

	if(ch == TAG_HANDLE){
	    HD(f)->centered->embedded = -1; /* next ch is length */
	}
	else if(ch == TAG_FGCOLOR || ch == TAG_BGCOLOR){
	    if(!HD(f)->color)
	      HD(f)->color = new_color_pair(NULL, NULL);
	    
	    if(ch == TAG_FGCOLOR)
	      color_ptr = HD(f)->color->fg;
	    else
	      color_ptr = HD(f)->color->bg;

	    HD(f)->centered->embedded = 11;
	}
	else if(HD(f)->centered->embedded < 0){
	    HD(f)->centered->embedded = ch; /* number of embedded chars */
	}
	else{
	    HD(f)->centered->embedded--;
	    if(color_ptr)
	      *color_ptr++ = ch;
	    
	    if(HD(f)->centered->embedded == 0 && color_ptr){
		*color_ptr = '\0';
		color_ptr = NULL;
	    }
	}

	html_centered_putc(&HD(f)->centered->word, ch);
    }
    else if(isspace((unsigned char) ch)){
	if(!HD(f)->centered->space++){	/* end of a word? flush! */
	    int i;

	    if(WRAPPED_LEN(f) > HD(f)->wrapcol){
		html_centered_flush_line(f);
		/* fall thru to put current "word" on blank "line" */
	    }
	    else if(HD(f)->centered->line.width){
		/* put space char between line and appended word */
		html_centered_putc(&HD(f)->centered->line, ' ');
		HD(f)->centered->line.width++;
	    }

	    for(i = 0; i < HD(f)->centered->word.used; i++)
	      html_centered_putc(&HD(f)->centered->line,
				 HD(f)->centered->word.buf[i]);

	    HD(f)->centered->line.width += HD(f)->centered->word.width;
	    HD(f)->centered->word.used  = 0;
	    HD(f)->centered->word.width = 0;
	}
    }
    else{
	if(HD(f)->prefix)
	  html_a_prefix(f);

	/* ch is start of next word */
	HD(f)->centered->space = 0;
	if(HD(f)->centered->word.width >= WRAP_COLS(f))
	  html_centered_flush(f);

	html_centered_putc(&HD(f)->centered->word, ch);
	HD(f)->centered->word.width++;
    }
}


/*
 * html_centered_putc -- add given char to given WRAPLINE_S
 */
void
html_centered_putc(wp, ch)
    WRAPLINE_S *wp;
    int		ch;
{
    if(wp->used + 1 >= wp->len){
	wp->len += 64;
	fs_resize((void **) &wp->buf, wp->len * sizeof(char));
    }

    wp->buf[wp->used++] = ch;
}



/*
 * html_centered_flush - finish writing any pending centered output
 */
void
html_centered_flush(f)
    FILTER_S *f;
{
    int i, h;

    /*
     * If word present (what about line?) we need to deal with
     * appending it...
     */
    if(HD(f)->centered->word.width && WRAPPED_LEN(f) > HD(f)->wrapcol)
      html_centered_flush_line(f);

    if(WRAPPED_LEN(f)){
	/* figure out how much to indent */
	if((i = (WRAP_COLS(f) - WRAPPED_LEN(f))/2) > 0)
	  html_write_indent(f, i);

	if(HD(f)->centered->anchor)
	  html_write_anchor(f, HD(f)->centered->anchor);

	html_centered_handle(&HD(f)->centered->anchor,
			     HD(f)->centered->line.buf,
			     HD(f)->centered->line.used);
	html_write(f, HD(f)->centered->line.buf, HD(f)->centered->line.used);

	if(HD(f)->centered->word.used){
	    if(HD(f)->centered->line.width)
	      html_putc(f, ' ');

	    html_centered_handle(&HD(f)->centered->anchor,
				 HD(f)->centered->word.buf,
				 HD(f)->centered->word.used);
	    html_write(f, HD(f)->centered->word.buf,
		       HD(f)->centered->word.used);
	}

	HD(f)->centered->line.used  = HD(f)->centered->word.used  = 0;
	HD(f)->centered->line.width = HD(f)->centered->word.width = 0;
    }
    else
      HD(f)->blanks++;			/* advance the blank line counter */

    html_newline(f);			/* finish the line */
}


/*
 * html_centered_handle - scan the line for embedded handles
 */
void
html_centered_handle(h, line, len)
    int  *h;
    char *line;
    int   len;
{
    int n;

    while(len-- > 0)
      if(*line++ == TAG_EMBED && len-- > 0)
	switch(*line++){
	  case TAG_HANDLE :
	    if((n = *line++) >= --len){
		*h = 0;
		len -= n;
		while(n--)
		  *h = (*h * 10) + (*line++ - '0');
	    }
	    break;

	  case TAG_HANDLEOFF :
	  case TAG_INVOFF :
	    *h = 0;		/* assumption 23,342: inverse off ends tags */
	    break;

	  default :
	    break;
	}
}



/*
 * html_centered_flush_line - flush the centered "line" only
 */
void
html_centered_flush_line(f)
    FILTER_S *f;
{
    if(HD(f)->centered->line.used){
	int i, j;

	/* hide "word" from flush */
	i = HD(f)->centered->word.used;
	j = HD(f)->centered->word.width;
	HD(f)->centered->word.used  = 0;
	HD(f)->centered->word.width = 0;
	html_centered_flush(f);

	HD(f)->centered->word.used  = i;
	HD(f)->centered->word.width = j;
    }
}


/*
 * html_write_indent - write indention mindful of display attributes
 */
void
html_write_indent(f, indent)
    FILTER_S *f;
    int	      indent;
{
    if(! STRIP(f)){
	if(BOLD_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_BOLDOFF);
	}

	if(ULINE_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_ULINEOFF);
	}
    }

    f->n = indent;
    while(indent-- > 0)
      html_putc(f, ' ');		/* indent as needed */

    /*
     * Resume any previous embedded state
     */
    if(! STRIP(f)){
	if(BOLD_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_BOLDON);
	}

	if(ULINE_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_ULINEON);
	}
    }
}


/*
 *
 */
void
html_write_anchor(f, anchor)
    FILTER_S *f;
    int	      anchor;
{
    char buf[256];
    int  i;

    html_putc(f, TAG_EMBED);
    html_putc(f, TAG_HANDLE);
    sprintf(buf, "%d", anchor);
    html_putc(f, (int) strlen(buf));

    for(i = 0; buf[i]; i++)
      html_putc(f, buf[i]);
}


/*
 * html_write_newline - write a newline mindful of display attributes
 */
void
html_write_newline(f)
    FILTER_S *f;
{
    if(! STRIP(f)){			/* First tie, off any embedded state */
	if(HD(f)->in_anchor){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_INVOFF);
	}

	if(BOLD_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_BOLDOFF);
	}

	if(ULINE_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_ULINEOFF);
	}

	if(HD(f)->color && HD(f)->color->fg[0] && HD(f)->color->bg[0]){
	    char        *p;
	    int          i;

	    p = color_embed(ps_global->VAR_NORM_FORE_COLOR,
			    ps_global->VAR_NORM_BACK_COLOR);
	    for(i = 0; i < 2 * (RGBLEN + 2); i++)
	      html_putc(f, p[i]);
	}
    }

    html_write(f, "\015\012", 2);

    if(! STRIP(f)){			/* First tie, off any embedded state */
	if(BOLD_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_BOLDON);
	}

	if(ULINE_BIT(f)){
	    html_putc(f, TAG_EMBED);
	    html_putc(f, TAG_ULINEON);
	}

	if(HD(f)->color && HD(f)->color->fg[0] && HD(f)->color->bg[0]){
	    char        *p;
	    int          i;
	    COLOR_PAIR  *tmp;

	    tmp = new_color_pair(HD(f)->color->fg, HD(f)->color->bg);
	    if(pico_is_good_colorpair(tmp)){
		p = color_embed(HD(f)->color->fg, HD(f)->color->bg);
		for(i = 0; i < 2 * (RGBLEN + 2); i++)
		  html_putc(f, p[i]);
	    }

	    HD(f)->color->fg[0] = '\0';
	    HD(f)->color->bg[0] = '\0';

	    if(tmp)
	      free_color_pair(&tmp);
	}
    }
}


/*
 * html_write - write given int array to the next filter.
 */
void
html_write(f, s, n)
    FILTER_S *f;
    char     *s;
    int	      n;
{
    GF_INIT(f, f->next);

    while(n-- > 0){
	/* keep track of attribute state?  Not if last char! */
	if(*s == TAG_EMBED && n-- > 0){
	    GF_PUTC(f->next, TAG_EMBED);
	    switch(*++s){
	      case TAG_BOLDON :
		BOLD_BIT(f) = 1;
		break;
	      case TAG_BOLDOFF :
		BOLD_BIT(f) = 0;
		break;
	      case TAG_ULINEON :
		ULINE_BIT(f) = 1;
		break;
	      case TAG_ULINEOFF :
		ULINE_BIT(f) = 0;
		break;
	      case TAG_HANDLEOFF :
		HD(f)->in_anchor = 0;
		GF_PUTC(f->next, TAG_INVOFF);
		s++;
		continue;
	      case TAG_HANDLE :
		if(n-- > 0){
		    int i = *++s;

		    GF_PUTC(f->next, TAG_HANDLE);
		    if(i <= n){
			n -= i;
			GF_PUTC(f->next, i);
			HD(f)->in_anchor = 0;
			while(1){
			    HD(f)->in_anchor = (HD(f)->in_anchor * 10)
								+ (*++s - '0');
			    if(--i)
			      GF_PUTC(f->next, *s);
			    else
			      break;
			}
		    }
		}

		break;
	      default:
		break;
	    }
	}

	GF_PUTC(f->next, (*s++) & 0xff);
    }

    GF_IP_END(f->next);			/* clean up next's input pointers */
}


/*
 * html_putc -- actual work of writing to next filter.
 *		NOTE: Small opt not using full GF_END since our input
 *		      pointers don't need adjusting.
 */
void
html_putc(f, ch)
    FILTER_S *f;
    int	      ch;
{
    GF_INIT(f, f->next);
    GF_PUTC(f->next, ch & 0xff);
    GF_IP_END(f->next);			/* clean up next's input pointers */
}



/*
 * Only current option is to turn on embedded data stripping for text
 * bound to a printer or composer.
 */
void *
gf_html2plain_opt(base, columns, flags)
    char *base;
    int	  columns, flags;
{
    HTML_OPT_S *op;

    op = (HTML_OPT_S *) fs_get(sizeof(HTML_OPT_S));

    op->base	    = cpystr(base);
    op->columns	    = columns;
    op->strip	    = ((flags & GFHP_STRIPPED) == GFHP_STRIPPED);
    op->handles	    = ((flags & GFHP_HANDLES) == GFHP_HANDLES);
    op->handles_loc = ((flags & GFHP_LOCAL_HANDLES) == GFHP_LOCAL_HANDLES);
    return((void *) op);
}


/* END OF HTML-TO-PLAIN text filter */

/*
 * ESCAPE CODE FILTER - remove unknown and possibly dangerous escape codes
 * from the text stream.
 */

#define	MAX_ESC_LEN	5

/*
 * the simple filter, removes unknown escape codes from the stream
 */
void
gf_escape_filter(f, flg)
    FILTER_S *f;
    int       flg;
{
    register char *p;
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;

	while(GF_GETC(f, c)){

	    if(state){
		if(c == '\033' || f->n == MAX_ESC_LEN){
		    f->line[f->n] = '\0';
		    f->n = 0L;
		    if(!match_escapes(f->line)){
			GF_PUTC(f->next, '^');
			GF_PUTC(f->next, '[');
		    }
		    else
		      GF_PUTC(f->next, '\033');

		    p = f->line;
		    while(*p)
		      GF_PUTC(f->next, *p++);

		    if(c == '\033')
		      continue;
		    else
		      state = 0;			/* fall thru */
		}
		else{
		    f->line[f->n++] = c;		/* collect */
		    continue;
		}
	    }

	    if(c == '\033')
	      state = 1;
	    else
	      GF_PUTC(f->next, c);
	}

	f->f1 = state;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	if(f->f1){
	    if(!match_escapes(f->line)){
		GF_PUTC(f->next, '^');
		GF_PUTC(f->next, '[');
	    }
	    else
	      GF_PUTC(f->next, '\033');
	}

	for(p = f->line; f->n; f->n--, p++)
	  GF_PUTC(f->next, *p);

	fs_give((void **)&(f->line));	/* free temp line buffer */
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset escape\n"));
	f->f1    = 0;
	f->n     = 0L;
	f->linep = f->line = (char *)fs_get((MAX_ESC_LEN + 1) * sizeof(char));
    }
}



/*
 * CONTROL CHARACTER FILTER - transmogrify control characters into their
 * corresponding string representations (you know, ^blah and such)...
 */

/*
 * the simple filter transforms unknown control characters in the stream
 * into harmless strings.
 */
void
gf_control_filter(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;

	while(GF_GETC(f, c)){

	    if(iscntrl(c & 0x7f)
	       && !(isspace((unsigned char) c)
		    || c == '\016' || c == '\017' || c == '\033')){
		GF_PUTC(f->next, '^');
		GF_PUTC(f->next, c + '@');
	    }
	    else
	      GF_PUTC(f->next, c);
	}

	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
}



/*
 * LINEWRAP FILTER - insert CRLF's at end of nearest whitespace before
 * specified line width
 */


typedef struct wrap_col_s {
    unsigned	bold:1;
    unsigned	uline:1;
    unsigned	inverse:1;
    unsigned	tags:1;
    unsigned	do_indent:1;
    unsigned	on_comma:1;
    unsigned	quoted:1;
    COLOR_PAIR *color;
    short	embedded,
		space_len;
    char       *lineendp,
		space;
    int		anchor;
    int		wrap_col,
		wrap_max,
		indent;
    char	special[256];
} WRAP_S;


#define	WRAP_COL(F)	(((WRAP_S *)(F)->opt)->wrap_col)
#define	WRAP_MAX_COL(F)	(((WRAP_S *)(F)->opt)->wrap_max)
#define	WRAP_INDENT(F)	(((WRAP_S *)(F)->opt)->indent)
#define	WRAP_DO_IND(F)	(((WRAP_S *)(F)->opt)->do_indent)
#define	WRAP_COMMA(F)	(((WRAP_S *)(F)->opt)->on_comma)
#define	WRAP_QUOTED(F)	(((WRAP_S *)(F)->opt)->quoted)
#define	WRAP_TAGS(F)	(((WRAP_S *)(F)->opt)->tags)
#define	WRAP_BOLD(F)	(((WRAP_S *)(F)->opt)->bold)
#define	WRAP_ULINE(F)	(((WRAP_S *)(F)->opt)->uline)
#define	WRAP_INVERSE(F)	(((WRAP_S *)(F)->opt)->inverse)
#define	WRAP_COLOR(F)	(((WRAP_S *)(F)->opt)->color)
#define	WRAP_LASTC(F)	(((WRAP_S *)(F)->opt)->lineendp)
#define	WRAP_EMBED(F)	(((WRAP_S *)(F)->opt)->embedded)
#define	WRAP_ANCHOR(F)	(((WRAP_S *)(F)->opt)->anchor)
#define	WRAP_SPACE(F)	(((WRAP_S *)(F)->opt)->space)
#define	WRAP_SPACES(F)	(WRAP_SPACE(F) ? (((WRAP_S *)(F)->opt)->space_len): 0)
#define	WRAP_SPC_LEN(F)	(((WRAP_S *)(F)->opt)->space_len)
#define	WRAP_SPEC(S, C)	(S)[C]

#define	WRAP_EOL(F)	{						\
			    if(WRAP_BOLD(F)){				\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_BOLDOFF);	\
			    }						\
			    if(WRAP_ULINE(F)){				\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_ULINEOFF);	\
			    }						\
			    if(WRAP_INVERSE(F) || WRAP_ANCHOR(F)){	\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_INVOFF);		\
			    }						\
			    if(WRAP_COLOR(F)){				\
				char *p;				\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_FGCOLOR);	\
				p = color_to_asciirgb(ps_global->VAR_NORM_FORE_COLOR);\
				for(; *p; p++)				\
				  GF_PUTC((F)->next, *p);		\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_BGCOLOR);	\
				p = color_to_asciirgb(ps_global->VAR_NORM_BACK_COLOR);\
				for(; *p; p++)				\
				  GF_PUTC((F)->next, *p);		\
			    }						\
			    GF_PUTC((F)->next, '\015');			\
			    GF_PUTC((F)->next, '\012');			\
			    f->n = 0L;					\
			    WRAP_SPACE(F) = 0;				\
			}

#define	WRAP_BOL(F)	{						\
			    if(WRAP_BOLD(F)){				\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_BOLDON);		\
			    }						\
			    if(WRAP_ULINE(F)){				\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_ULINEON);	\
			    }						\
			    if(WRAP_INVERSE(F)){			\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_INVON);		\
			    }						\
			    if(WRAP_COLOR(F)){				\
				char *p;				\
				if(WRAP_COLOR(F)->fg[0]){		\
				  GF_PUTC((F)->next, TAG_EMBED);	\
				  GF_PUTC((F)->next, TAG_FGCOLOR);	\
				  p = color_to_asciirgb(WRAP_COLOR(F)->fg);\
				  for(; *p; p++)			\
				    GF_PUTC((F)->next, *p);		\
				}					\
				if(WRAP_COLOR(F)->bg[0]){		\
				  GF_PUTC((F)->next, TAG_EMBED);	\
				  GF_PUTC((F)->next, TAG_BGCOLOR);	\
				  p = color_to_asciirgb(WRAP_COLOR(F)->bg);\
				  for(; *p; p++)			\
				    GF_PUTC((F)->next, *p);		\
				}					\
			    }						\
			    if(WRAP_ANCHOR(F)){				\
				char buf[64]; int i;			\
				GF_PUTC((F)->next, TAG_EMBED);		\
				GF_PUTC((F)->next, TAG_HANDLE);		\
				sprintf(buf, "%d", WRAP_ANCHOR(F));	\
				GF_PUTC((F)->next, (int) strlen(buf));	\
				for(i = 0; buf[i]; i++)			\
				  GF_PUTC((F)->next, buf[i]);		\
			    }						\
			}

#define	WRAP_PUTC(F,C)	{						\
			    if((F)->linep == WRAP_LASTC(F)){		\
				size_t offset = (F)->linep - (F)->line;	\
				fs_resize((void **) &(F)->line,		\
					  (2 * offset) * sizeof(char)); \
				(F)->linep = &(F)->line[offset];	\
				WRAP_LASTC(F) = &(F)->line[2*offset-1];	\
			    }						\
			    *(F)->linep++ = (C);			\
			}

#define	WRAP_FLUSH(F)	{						\
			    register char *s = f->line;			\
			    register int   n;				\
			    if(!f->n){					\
				if(WRAP_DO_IND(F)){			\
				    if(f->n = (long)(n = WRAP_INDENT(F))) \
				      while(n-- > 0)			\
					GF_PUTC((F)->next, ' ');	\
				    WRAP_DO_IND(F) = 0;			\
				}					\
				WRAP_BOL(F);				\
			    }						\
			    if(WRAP_SPACE(F)){				\
				GF_PUTC(f->next, WRAP_SPACE(F));	\
				WRAP_SPACE(F) = 0;			\
				f->n += WRAP_SPC_LEN(F);		\
			    }						\
			    for(n = f->linep - f->line; n > 0; n--){	\
				if(*s == TAG_EMBED){			\
				    if(n-- > 0){			\
					GF_PUTC(f->next, TAG_EMBED);	\
					switch(*++s){			\
					  case TAG_BOLDON :		\
					    WRAP_BOLD(f) = 1;		\
					    break;			\
					  case TAG_BOLDOFF :		\
					    WRAP_BOLD(f) = 0;		\
					    break;			\
					  case TAG_ULINEON :		\
					    WRAP_ULINE(f) = 1;		\
					    break;			\
					  case TAG_ULINEOFF :		\
					    WRAP_ULINE(f) = 0;		\
					    break;			\
					  case TAG_INVOFF :		\
					    WRAP_ANCHOR(f) = 0;		\
					    break;			\
					  case TAG_HANDLE :		\
					    if(n-- > 0){		\
						int i = *++s;		\
						GF_PUTC(f->next, TAG_HANDLE); \
						if(i <= n){		\
						    n -= i;		\
						    GF_PUTC(f->next, i); \
						    WRAP_ANCHOR(f) = 0;	\
						    while(1){		\
							WRAP_ANCHOR(f)	\
							  = (WRAP_ANCHOR(f) \
							        * 10)	\
								+ (*++s-'0');\
							if(--i)		\
							  GF_PUTC(f->next,*s);\
							else		\
							  break;	\
						    }			\
						}			\
					    }				\
					    break;			\
					  case TAG_FGCOLOR :		\
					    if(pico_usingcolor()	\
					       && n >= RGBLEN){		\
					      if(!WRAP_COLOR(f))	\
						WRAP_COLOR(f)=new_color_pair(NULL,NULL); \
					      strncpy(WRAP_COLOR(f)->fg, \
						      s+1, RGBLEN);	\
					      WRAP_COLOR(f)->fg[RGBLEN]='\0'; \
					      i = RGBLEN;		\
					      n -= i;			\
					      while(i-- > 0)		\
						GF_PUTC(f->next,	\
							(*s++) & 0xff);	\
					    }				\
					    break;			\
					  case TAG_BGCOLOR :		\
					    if(pico_usingcolor()	\
					       && n >= RGBLEN){		\
					      if(!WRAP_COLOR(f))	\
						WRAP_COLOR(f)=new_color_pair(NULL,NULL); \
					      strncpy(WRAP_COLOR(f)->bg,\
						      s+1, RGBLEN);	\
					      WRAP_COLOR(f)->bg[RGBLEN]='\0'; \
					      i = RGBLEN;		\
					      n -= i;			\
					      while(i-- > 0)		\
						GF_PUTC(f->next,	\
							(*s++) & 0xff);	\
					    }				\
					    break;			\
					  default :			\
					    break;			\
					}				\
				    }					\
				}					\
				else					\
				  f->n++;				\
				GF_PUTC(f->next, (*s++) & 0xff);	\
			    }						\
			    f->f2    = 0;				\
			    f->linep = f->line;				\
			}




/*
 * the simple filter, breaks lines at end of white space nearest
 * to global "gf_wrap_width" in length
 */
void
gf_wrap(f, flg)
    FILTER_S *f;
    int       flg;
{
    register long i;
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;
	int	     wrap_threshold = WRAP_MAX_COL(f) - WRAP_INDENT(f);
	char	    *special = ((WRAP_S *) f->opt)->special;

	while(GF_GETC(f, c)){

	    switch(state){
	      case CCR :
		state = DFL;			/* CRLF or CR in text ? */
		WRAP_FLUSH(f);			/* it's a newline to us */
		WRAP_EOL(f);
		WRAP_BOL(f);
		if(c == '\012')			/* process anything but LF */
		  break;

	      case DFL :
		if(WRAP_SPEC(special, c))
		  switch(c){
		    default :
		      if(WRAP_QUOTED(f))
			break;

		      WRAP_FLUSH(f);		/* flush buf */
		      switch(WRAP_SPACE(f) = c){ /* remember separator */
			case ' ' :
			  WRAP_SPC_LEN(f) = 1;
			  break;

			case TAB :
			{
			    int i = (int) f->n;
			    while(++i & 0x07)
			      ;

			    WRAP_SPC_LEN(f) = i - (int) f->n;
			}

			break;

			default :		/* some control char? */
			  WRAP_SPC_LEN(f) = 2;
			  break;
		      }

		      continue;

		    case '\"' :
		      WRAP_QUOTED(f) = !WRAP_QUOTED(f);
		      break;

		    case '\015' :		/* already has newline? */
		      state = CCR;
		      continue;

		    case '\012' :		/* bare LF in text? */
		      WRAP_FLUSH(f);		/* they must've meant */
		      WRAP_EOL(f);		/* newline... */
		      WRAP_BOL(f);
		      continue;

		    case (unsigned char) TAG_EMBED :
		      WRAP_PUTC(f, TAG_EMBED);
		      state = TAG;
		      continue;

		    case ',' :
		      if(!WRAP_QUOTED(f)){
			  WRAP_PUTC(f, ',');
			  WRAP_FLUSH(f);
			  WRAP_SPACE(f) = 0;
			  continue;
		      }

		      break;
		  }

		if(!f->n && (f->f2 >= wrap_threshold)){
		    char *ep, *space = NULL;
		    int   cntr, new_f2;

		    /* Flush the buf'd line up to last WS */
		    if(WRAP_COMMA(f)){
			char *p;

			new_f2 = cntr = f->f2;
			for(p = f->line; p < f->linep; p++){
			    /*
			     * Don't split at WS which is in the middle
			     * of a tag.
			     */
			    switch((unsigned char)*p){
			      case (unsigned char)TAG_EMBED:
				if(++p >= f->linep)
				  break;

				switch(*p){
				  case TAG_FGCOLOR:
				  case TAG_BGCOLOR:
				    p += RGBLEN;
				    break;

				  case TAG_HANDLE:
				    if(++p >= f->linep)
				      break;
					
				    p += (*p);
				    break;

				  default:
				    break;
				}

				continue;
				break;
				
			      default:
				break;
			    }
				
			    cntr--;

			    if(p < f->linep && isspace((unsigned char)*p)){
				space = p;
				new_f2 = cntr;
			    }
			}

			if(space){
			    ep = f->linep;
			    f->linep = space;
			}
		    }

		    WRAP_FLUSH(f);		/* write buffered */
		    WRAP_EOL(f);		/* write end of line */
		    WRAP_DO_IND(f) = 1;		/* indent next line */

		    if(space){
			f->linep = f->line;
			while(++space < ep)
			  *f->linep++ = *space;

			f->f2 = new_f2;
		    }
		}

		WRAP_PUTC(f, c);

		if(c == '\t' && WRAP_COMMA(f)){
		    int i = (int) f->n;
		    while(++i & 0x07)
		      ;

		    f->f2 += i - (int) f->n;
		}
		else
		  f->f2++;

		if(f->n && (f->n + f->f2 + WRAP_SPACES(f) >= WRAP_COL(f))){
		    WRAP_EOL(f);		/* write end of line */
		    WRAP_DO_IND(f) = 1;		/* indent next line */
		}

		break;

	      case TAG :
		WRAP_PUTC(f, c);
		switch(c){
		  case TAG_HANDLE :
		    WRAP_EMBED(f) = -1;
		    state = HANDLE;
		    break;

		  case TAG_FGCOLOR :
		  case TAG_BGCOLOR :
		    WRAP_EMBED(f) = RGBLEN;
		    state = HDATA;
		    break;

		  default :
		    state = DFL;
		    break;
		}

		break;

	      case HANDLE :
		WRAP_PUTC(f, c);
		WRAP_EMBED(f) = c;
		state = HDATA;
		break;

	      case HDATA :
		WRAP_PUTC(f, c);
		if(!(WRAP_EMBED(f) -= 1))
		  state = DFL;

		break;
	    }
	}

	f->f1 = state;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	WRAP_FLUSH(f);
	if(WRAP_COLOR(f))
	  free_color_pair(&WRAP_COLOR(f));

	fs_give((void **) &f->line);	/* free temp line buffer */
	fs_give((void **) &f->opt);	/* free wrap widths struct */
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset wrap\n"));
	f->f1    = DFL;
	f->n     = 0L;		/* displayed length of line so far */
	f->f2	 = 0;		/* displayed length of buffered chars */
	if(! (WRAP_S *) f->opt)
	  f->opt = gf_wrap_filter_opt(75, 80, 0, 0);

	while(WRAP_INDENT(f) >= WRAP_MAX_COL(f))
	  WRAP_INDENT(f) /= 2;

	f->line  = (char *) fs_get(WRAP_MAX_COL(f) * sizeof(char));
	f->linep = f->line;
	WRAP_LASTC(f) = &f->line[WRAP_MAX_COL(f) - 1];

	for(i = 0; i < 256; i++)
	  ((WRAP_S *) f->opt)->special[i] = ((i == '\"' && WRAP_COMMA(f))
					     || i == '\015'
					     || i == '\012'
					     || (i == (unsigned char) TAG_EMBED
						 && WRAP_TAGS(f))
					     || (i == ',' && WRAP_COMMA(f)
						 && !WRAP_QUOTED(f))
					     || (!WRAP_COMMA(f)
					      && isspace((unsigned char) i)));
    }
}


/*
 * function called from the outside to set
 * wrap filter's width option
 */
void *
gf_wrap_filter_opt(width, width_max, indent, flags)
    int width, width_max, indent, flags;
{
    WRAP_S *wrap;

    wrap = (WRAP_S *) fs_get(sizeof(WRAP_S));
    memset(wrap, 0, sizeof(WRAP_S));
    wrap->wrap_col = width;
    wrap->wrap_max = width_max;
    wrap->indent   = indent;
    wrap->tags	   = (GFW_HANDLES & flags) == GFW_HANDLES;
    wrap->on_comma = (GFW_ONCOMMA & flags) == GFW_ONCOMMA;
    return((void *) wrap);
}




/*
 * LINE PREFIX FILTER - insert given text at beginning of each
 * line
 */


#define	GF_PREFIX_WRITE(s)	{ \
				    register char *p; \
				    if(p = (s)) \
				      while(*p) \
					GF_PUTC(f->next, *p++); \
				}


/*
 * the simple filter, prepends each line with the requested prefix.
 * if prefix is null, does nothing, and as with all filters, assumes
 * NVT end of lines.
 */
void
gf_prefix(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;
	register int first = f->f2;

	while(GF_GETC(f, c)){

	    if(first){			/* write initial prefix!! */
		first = 0;		/* but just once */
		GF_PREFIX_WRITE((char *) f->opt);
	    }
	    else if(state){
		state = 0;
		GF_PUTC(f->next, '\015');
		if(c == '\012'){
		    GF_PUTC(f->next, '\012');
		    GF_PREFIX_WRITE((char *) f->opt);
		    continue;
		}
		/* else fall thru to handle 'c' */
	    }

	    if(c == '\015')		/* already has newline? */
	      state = 1;
	    else
	      GF_PUTC(f->next, c);
	}

	f->f1 = state;
	f->f2 = first;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset prefix\n"));
	f->f1   = 0;
	f->f2   = 1;			/* nothing written yet */
    }
}


/*
 * function called from the outside to set
 * prefix filter's prefix string
 */
void *
gf_prefix_opt(prefix)
    char *prefix;
{
    return((void *) prefix);
}


/*
 * LINE TEST FILTER - accumulate lines and offer each to the provided
 * test function.
 */

typedef struct _linetest_s {
    linetest_t	f;
    void       *local;
} LINETEST_S;


/* accumulator growth increment */
#define	LINE_TEST_BLOCK	1024

#define	GF_LINE_TEST_EOB(f) \
			((f)->line + ((f)->f2 - 1))

#define	GF_LINE_TEST_ADD(f, c) \
			{ \
				    if(p >= eobuf){ \
					f->f2 += LINE_TEST_BLOCK; \
					fs_resize((void **)&f->line, \
					      (size_t) f->f2 * sizeof(char)); \
					eobuf = GF_LINE_TEST_EOB(f); \
					p = eobuf - LINE_TEST_BLOCK; \
				    } \
				    *p++ = c; \
				}

#define	GF_LINE_TEST_TEST(F, D) \
			{ \
			    unsigned char  c; \
			    register char *cp; \
			    register int   l; \
			    LT_INS_S	  *ins = NULL, *insp; \
			    *p = '\0'; \
			    (D) = (*((LINETEST_S *) (F)->opt)->f)((F)->n++, \
					   (F)->line, &ins, \
					   ((LINETEST_S *) (F)->opt)->local); \
			    if((D) < 2){ \
				for(insp = ins, cp = (F)->line; cp < p; ){ \
				    while(insp && cp == insp->where){ \
					for(l = 0; l < insp->len; l++){ \
					    c = (unsigned char) insp->text[l];\
					    GF_PUTC((F)->next, c); \
					} \
					insp = insp->next; \
				    } \
				    GF_PUTC((F)->next, *cp); \
				    cp++; \
				} \
				while(insp){ \
				    for(l = 0; l < insp->len; l++){ \
					c = (unsigned char) insp->text[l]; \
					GF_PUTC((F)->next, c); \
				    } \
				    insp = insp->next; \
				} \
				gf_line_test_free_ins(&ins); \
			    } \
			}



/*
 * this simple filter accumulates characters until a newline, offers it
 * to the provided test function, and then passes it on.  It assumes
 * NVT EOLs.
 */
void
gf_line_test(f, flg)
    FILTER_S *f;
    int	      flg;
{
    register char *p = f->linep;
    register char *eobuf = GF_LINE_TEST_EOB(f);
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;

	while(GF_GETC(f, c)){

	    if(state){
		state = 0;
		if(c == '\012'){
		    int done;

		    GF_LINE_TEST_TEST(f, done);

		    p = (f)->line;

		    if(done == 2)	/* skip this line! */
		      continue;

		    GF_PUTC(f->next, '\015');
		    GF_PUTC(f->next, '\012');
		    /*
		     * if the line tester returns TRUE, it's
		     * telling us its seen enough and doesn't
		     * want to see any more.  Remove ourself
		     * from the pipeline...
		     */
		    if(done){
			if(gf_master == f){
			    gf_master = f->next;
			}
			else{
			    FILTER_S *fprev;

			    for(fprev = gf_master;
				fprev && fprev->next != f;
				fprev = fprev->next)
			      ;

			    if(fprev)		/* wha??? */
			      fprev->next = f->next;
			    else
			      continue;
			}

			while(GF_GETC(f, c))	/* pass input */
			  GF_PUTC(f->next, c);

			GF_FLUSH(f->next);	/* and drain queue */
			fs_give((void **)&f->line);
			fs_give((void **)&f);	/* wax our data */
			return;
		    }
		    else
		      continue;
		}
		else			/* add CR to buffer */
		  GF_LINE_TEST_ADD(f, '\015');
	    } /* fall thru to handle 'c' */

	    if(c == '\015')		/* newline? */
	      state = 1;
	    else
	      GF_LINE_TEST_ADD(f, c);
	}

	f->f1 = state;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	int i;

	GF_LINE_TEST_TEST(f, i);	/* examine remaining data */
	fs_give((void **) &f->line);	/* free line buffer */
	fs_give((void **) &f->opt);	/* free test struct */
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset line_test\n"));
	f->f1 = 0;			/* state */
	f->n  = 0L;			/* line number */
	f->f2 = LINE_TEST_BLOCK;	/* size of alloc'd line */
	f->line = p = (char *) fs_get(f->f2 * sizeof(char));
    }

    f->linep = p;
}


/*
 * function called from the outside to operate on accumulated line.
 */
void *
gf_line_test_opt(test_f, local)
    linetest_t  test_f;
    void       *local;
{
    LINETEST_S *ltp;

    ltp = (LINETEST_S *) fs_get(sizeof(LINETEST_S));
    memset(ltp, 0, sizeof(LINETEST_S));
    ltp->f     = test_f;
    ltp->local = local;
    return((void *) ltp);
}



LT_INS_S **
gf_line_test_new_ins(ins, p, s, n)
    LT_INS_S **ins;
    char      *p, *s;
    int	       n;
{
    *ins = (LT_INS_S *) fs_get(sizeof(LT_INS_S));
    if((*ins)->len = n)
      strncpy((*ins)->text = (char *) fs_get(n * sizeof(char)), s, n);

    (*ins)->where = p;
    (*ins)->next  = NULL;
    return(&(*ins)->next);
}


void
gf_line_test_free_ins(ins)
    LT_INS_S **ins;
{
    if(ins && *ins){
	if((*ins)->next)
	  gf_line_test_free_ins(&(*ins)->next);

	if((*ins)->text)
	  fs_give((void **) &(*ins)->text);

	fs_give((void **) ins);
    }
}


/*
 * Network virtual terminal to local newline convention filter
 */
void
gf_nvtnl_local(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;
	register int state = f->f1;

	while(GF_GETC(f, c)){
	    if(state){
		state = 0;
		if(c == '\012'){
		    GF_PUTC(f->next, '\012');
		    continue;
		}
		else
		  GF_PUTC(f->next, '\015');
		/* fall thru to deal with 'c' */
	    }

	    if(c == '\015')
	      state = 1;
	    else
	      GF_PUTC(f->next, c);
	}

	f->f1 = state;
	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset nvtnl_local\n"));
	f->f1 = 0;
    }
}


/*
 * local to network newline convention filter
 */
void
gf_local_nvtnl(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;

	while(GF_GETC(f, c)){
	    if(c == '\012'){
		GF_PUTC(f->next, '\015');
		GF_PUTC(f->next, '\012');
	    }
	    else
	      GF_PUTC(f->next, c);
	}

	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(GF_RESET){
	dprint(9, (debugfile, "-- gf_reset local_nvtnl\n"));
	/* no op */
    }

}

#if defined(DOS) || defined(OS2)
/*
 * DOS CodePage to Character Set Translation (and back) filters
 */

/*
 * Charset and CodePage mapping table pointer and length
 */
static unsigned char *gf_xlate_tab;
static unsigned gf_xlate_tab_len;

/*
 * the simple filter takes DOS Code Page values and maps them into
 * the indicated external CharSet mapping or vice-versa.
 */
void
gf_translate(f, flg)
    FILTER_S *f;
    int       flg;
{
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;

	while(GF_GETC(f, c))
	  if((unsigned long) c < ((SIZEDTEXT *) (f->opt))->size)
	    GF_PUTC(f->next, (int) ((SIZEDTEXT *) (f->opt))->data[c]);

	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	fs_give((void **) &f->opt);	/* free up table description */
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(GF_RESET){
	dprint(9, (debugfile, "-- gf_reset translate\n"));
    }
}


/*
 * function called from the outside to set
 * prefix filter's prefix string
 */
void *
gf_translate_opt(xlatetab, xlatetablen)
    unsigned char *xlatetab;
    unsigned       xlatetablen;
{
    SIZEDTEXT *xlate_tab = (SIZEDTEXT *) fs_get(sizeof(SIZEDTEXT));

    xlate_tab->data = xlatetab;
    xlate_tab->size = (unsigned long) xlatetablen;

    return((void *) xlate_tab);
}
#endif

/*
 * display something indicating we're chewing on something
 *
 * NOTE : IF ANY OTHER FILTERS WRITE THE DISPLAY, THIS WILL NEED FIXING
 */
void
gf_busy(f, flg)
    FILTER_S *f;
    int       flg;
{
    static short x = 0;
    GF_INIT(f, f->next);

    if(flg == GF_DATA){
	register unsigned char c;

	while(GF_GETC(f, c)){

	    if(!((++(f->f1))&0x7ff)){ 	/* ding the bell every 2K chars */
		MoveCursor(0, 1);
		f->f1 = 0;
		if((++x)&0x04) x = 0;
		Writechar((x == 0) ? '/' : 	/* CHEATING! */
			  (x == 1) ? '-' :
			  (x == 2) ? '\\' : '|', 0);
	    }

	    GF_PUTC(f->next, c);
	}

	GF_END(f, f->next);
    }
    else if(flg == GF_EOD){
	MoveCursor(0, 1);
	Writechar(' ', 0);
	EndInverse();
	GF_FLUSH(f->next);
	(*f->next->f)(f->next, GF_EOD);
    }
    else if(flg == GF_RESET){
	dprint(9, (debugfile, "-- gf_reset busy\n"));
	f->f1 = 0;
        x = 0;
	StartInverse();
    }

    fflush(stdout);
}
