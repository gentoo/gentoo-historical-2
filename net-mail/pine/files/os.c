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
   1989-1998 by the University of Washington.

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

 This contains most of Pine's interface to the local operating system
and hardware.  Hopefully this file, os-xxx.h and makefile.xxx are the
only ones that have to be modified for most ports.  Signals.c, ttyin.c,
and ttyout.c also have some dependencies.  See the doc/tech-notes for
notes on porting Pine to other platforms.  Here is a list of the functions
required for an implementation:


  File System Access
     can_access          -- See if a file can be accessed
     name_file_size      -- Return the number of bytes in the file (by name)
     fp_file_size        -- Return the number of bytes in the file (by FILE *)
     name_file_mtime     -- Return the mtime of a file (by name)
     fp_file_mtime       -- Return the mtime of a file (by FILE *)
     file_attrib_copy    -- Copy attributes of one file to another.
     is_writable_dir     -- Check to see if directory exists and is writable
     create_mail_dir     -- Make a directory
     rename_file         -- change name of a file
     build_path          -- Put together a file system path
     last_cmpnt          -- Returns pointer to last component of path
     expand_foldername   -- Expand a folder name to full path
     fnexpand            -- Do filename exansion for csh style "~"
     filter_filename     -- Make sure file name hasn't got weird chars
     cntxt_allowed       -- Check whether a pathname is allowed for read/write
     disk_quota          -- Check the user's disk quota
     read_file           -- Read whole file into memory (for small files)
     create_tmpfile      -- Just like ANSI C tmpfile function
     temp_nam            -- Almost like common tempnam function
     fget_pos,fset_pos   -- Just like ANSI C fgetpos, fsetpos functions

  Abort
     coredump            -- Abort running Pine dumping core if possible

  System Name and Domain
     hostname            -- Figure out the system's host name, only
                              used internally in this file.
     getdomainnames      -- Figure out the system's domain name
     canonical_name      -- Returns canonical form of host name

  Job Control
     have_job_control    -- Returns 1 if job control exists
     stop_process        -- What to do to stop process when it's time to stop
			      (only used if have_job_control returns 1)

  System Error Messages (in case given one is a problem)
     error_description   -- Returns string describing error

  System Password and Accounts
     gcos_name           -- Parses full name from system, only used
			      locally in this file so if you don't use it you
			      don't need it
     get_user_info       -- Finds in login name, full name, and homedir
     local_name_lookup   -- Get full name of user on system
     change_passwd       -- Calls system password changer

  MIME utilities
     mime_can_display    -- Can we display this type/subtype?
     exec_mailcap_cmd    -- Run the mailcap command to view a type/subtype.
     exec_mailcap_test_cmd -- Run mailcap test= test command.

  Other stuff
     srandom             -- Dummy srandom if you don't have this function
     init_debug
     do_debug
     save_debug_on_crash

  ====*/


#include "headers.h"



/*----------------------------------------------------------------------
       Check if we can access a file in a given way

   Args: file      -- The file to check
         mode      -- The mode ala the access() system call, see ACCESS_EXISTS
                      and friends in pine.h.

 Result: returns 0 if the user can access the file according to the mode,
         -1 if he can't (and errno is set).
 ----*/
int
can_access(file, mode)
    char *file;
    int   mode;
{
    return(access(file, mode));
}


/*----------------------------------------------------------------------
       Check if we can access a file in a given way in the given path

   Args: path     -- The path to look for "file" in
	 file      -- The file to check
         mode      -- The mode ala the access() system call, see ACCESS_EXISTS
                      and friends in pine.h.

 Result: returns 0 if the user can access the file according to the mode,
         -1 if he can't (and errno is set).
 ----*/
can_access_in_path(path, file, mode)
    char *path, *file;
    int   mode;
{
    char tmp[MAXPATH], *path_copy, *p, *t;
    int  rv = -1;

    if(!path || !*path || *file == '/'){
	rv = access(file, mode);
    }
    else if(*file == '~'){
	strcpy(tmp, file);
	rv = fnexpand(tmp, sizeof(tmp)) ? access(tmp, mode) : -1;
    }
    else{
	for(p = path_copy = cpystr(path); p && *p; p = t){
	    if(t = strindex(p, ':'))
	      *t++ = '\0';

	    sprintf(tmp, "%s/%s", p, file);
	    if((rv = access(tmp, mode)) == 0)
	      break;
	}

	fs_give((void **)&path_copy);
    }

    return(rv);
}

/*----------------------------------------------------------------------
      Return the number of bytes in given file

    Args: file -- file name

  Result: the number of bytes in the file is returned or
          -1 on error, in which case errno is valid
 ----*/
long
name_file_size(file)
    char *file;
{
    struct stat buffer;

    if(stat(file, &buffer) != 0)
      return(-1L);

    return((long)buffer.st_size);
}


/*----------------------------------------------------------------------
      Return the number of bytes in given file

    Args: fp -- FILE * for open file

  Result: the number of bytes in the file is returned or
          -1 on error, in which case errno is valid
 ----*/
long
fp_file_size(fp)
    FILE *fp;
{
    struct stat buffer;

    if(fstat(fileno(fp), &buffer) != 0)
      return(-1L);

    return((long)buffer.st_size);
}


/*----------------------------------------------------------------------
      Return the modification time of given file

    Args: file -- file name

  Result: the time of last modification (mtime) of the file is returned or
          -1 on error, in which case errno is valid
 ----*/
time_t
name_file_mtime(file)
    char *file;
{
    struct stat buffer;

    if(stat(file, &buffer) != 0)
      return((time_t)(-1));

    return(buffer.st_mtime);
}


/*----------------------------------------------------------------------
      Return the modification time of given file

    Args: fp -- FILE * for open file

  Result: the time of last modification (mtime) of the file is returned or
          -1 on error, in which case errno is valid
 ----*/
time_t
fp_file_mtime(fp)
    FILE *fp;
{
    struct stat buffer;

    if(fstat(fileno(fp), &buffer) != 0)
      return((time_t)(-1));

    return(buffer.st_mtime);
}


/*----------------------------------------------------------------------
      Copy the mode, owner, and group of sourcefile to targetfile.

    Args: targetfile -- 
	  sourcefile --
    
    We don't bother keeping track of success or failure because we don't care.
 ----*/
void
file_attrib_copy(targetfile, sourcefile)
    char *targetfile;
    char *sourcefile;
{
    struct stat buffer;

    if(stat(sourcefile, &buffer) == 0){
	chmod(targetfile, buffer.st_mode);
#if !defined(DOS) && !defined(OS2)
	chown(targetfile, buffer.st_uid, buffer.st_gid);
#endif
    }
}



/*----------------------------------------------------------------------
      Check to see if a directory exists and is writable by us

   Args: dir -- directory name

 Result:       returns 0 if it exists and is writable
                       1 if it is a directory, but is not writable
                       2 if it is not a directory
                       3 it doesn't exist.
  ----*/
is_writable_dir(dir)
    char *dir;
{
    struct stat sb;

    if(stat(dir, &sb) < 0)
      /*--- It doesn't exist ---*/
      return(3);

    if(!(sb.st_mode & S_IFDIR))
      /*---- it's not a directory ---*/
      return(2);

    if(can_access(dir, 07))
      return(1);
    else
      return(0);
}



/*----------------------------------------------------------------------
      Create the mail subdirectory.

  Args: dir -- Name of the directory to create
 
 Result: Directory is created.  Returns 0 on success, else -1 on error
	 and errno is valid.
  ----*/
create_mail_dir(dir)
    char *dir;
{
    if(mkdir(dir, 0700) < 0)
      return(-1);

    (void)chmod(dir, 0700);
    /* Some systems need this, on others we don't care if it fails */
    (void)chown(dir, getuid(), getgid());
    return(0);
}



/*----------------------------------------------------------------------
      Rename a file

  Args: tmpfname -- Old name of file
        fname    -- New name of file
 
 Result: File is renamed.  Returns 0 on success, else -1 on error
	 and errno is valid.
  ----*/
rename_file(tmpfname, fname)
    char *tmpfname, *fname;
{
    return(rename(tmpfname, fname));
}



/*----------------------------------------------------------------------
      Paste together two pieces of a file name path

  Args: pathbuf      -- Put the result here
        first_part   -- of path name
        second_part  -- of path name
 
 Result: New path is in pathbuf.  No check is made for overflow.  Note that
	 we don't have to check for /'s at end of first_part and beginning
	 of second_part since multiple slashes are ok.

BUGS:  This is a first stab at dealing with fs naming dependencies, and others 
still exist.
  ----*/
void
build_path(pathbuf, first_part, second_part)
    char *pathbuf, *first_part, *second_part;
{
    if(!first_part)
      strcpy(pathbuf, second_part);
    else
      sprintf(pathbuf, "%s%s%s", first_part,
	      (*first_part && first_part[strlen(first_part)-1] != '/')
	        ? "/" : "",
	      second_part);
}


/*----------------------------------------------------------------------
  Test to see if the given file path is absolute

  Args: file -- file path to test

 Result: TRUE if absolute, FALSE otw

  ----*/
int
is_absolute_path(path)
    char *path;
{
    return(path && (*path == '/' || *path == '~'));
}



/*----------------------------------------------------------------------
      Return pointer to last component of pathname.

  Args: filename     -- The pathname.
 
 Result: Returned pointer points to last component in the input argument.
  ----*/
char *
last_cmpnt(filename)
    char *filename;
{
    register char *p = NULL, *q = filename;

    while(q = strchr(q, '/'))
      if(*++q)
	p = q;

    return(p);
}



/*----------------------------------------------------------------------
      Expand a folder name, taking account of the folders_dir and `~'.

  Args: filename -- The name of the file that is the folder
 
 Result: The folder name is expanded in place.  
         Returns 0 and queues status message if unsuccessful.
         Input string is overwritten with expanded name.
         Returns 1 if successful.

BUG should limit length to MAXPATH
  ----*/
int
expand_foldername(filename)
    char *filename;
{
    char         temp_filename[MAXPATH+1];

    dprint(5, (debugfile, "=== expand_foldername called (%s) ===\n",filename));

    /*
     * We used to check for valid filename chars here if "filename"
     * didn't refer to a remote mailbox.  This has been rethought
     */

    strcpy(temp_filename, filename);
    if(strucmp(temp_filename, "inbox") == 0) {
        strcpy(filename, ps_global->VAR_INBOX_PATH == NULL ? "inbox" :
               ps_global->VAR_INBOX_PATH);
    } else if(temp_filename[0] == '{') {
        strcpy(filename, temp_filename);
    } else if(ps_global->restricted
	        && (strindex("./~", temp_filename[0]) != NULL
		    || srchstr(temp_filename,"/../"))){
	q_status_message(SM_ORDER, 0, 3, "Can only open local folders");
	return(0);
    } else if(temp_filename[0] == '*') {
        strcpy(filename, temp_filename);
    } else if(ps_global->VAR_OPER_DIR && srchstr(temp_filename,"..")){
	q_status_message(SM_ORDER, 0, 3,
			 "\"..\" not allowed in folder name");
	return(0);
    } else if (temp_filename[0] == '~'){
        if(fnexpand(temp_filename, sizeof(temp_filename)) == NULL) {
            char *p = strindex(temp_filename, '/');
    	    if(p != NULL)
    	      *p = '\0';
    	    q_status_message1(SM_ORDER, 3, 3,
                    "Error expanding folder name: \"%s\" unknown user",
    	       temp_filename);
    	    return(0);
        }
        strcpy(filename, temp_filename);
    } else if(temp_filename[0] == '/') {
        strcpy(filename, temp_filename);
    } else if(F_ON(F_USE_CURRENT_DIR, ps_global)){
	strcpy(filename, temp_filename);
    } else if(ps_global->VAR_OPER_DIR){
	build_path(filename, ps_global->VAR_OPER_DIR, temp_filename);
    } else {
	build_path(filename, ps_global->home_dir, temp_filename);
    }
    dprint(5, (debugfile, "returning \"%s\"\n", filename));    
    return(1);
}



struct passwd *getpwnam();

/*----------------------------------------------------------------------
       Expand the ~ in a file ala the csh (as home directory)

   Args: buf --  The filename to expand (nothing happens unless begins with ~)
         len --  The length of the buffer passed in (expansion is in place)

 Result: Expanded string is returned using same storage as passed in.
         If expansion fails, NULL is returned
 ----*/
char *
fnexpand(buf, len)
    char *buf;
    int len;
{
    struct passwd *pw;
    register char *x,*y;
    char name[20];
    
    if(*buf == '~') {
        for(x = buf+1, y = name; *x != '/' && *x != '\0'; *y++ = *x++);
        *y = '\0';
        if(x == buf + 1) 
          pw = getpwuid(getuid());
        else
          pw = getpwnam(name);
        if(pw == NULL)
          return((char *)NULL);
        if(strlen(pw->pw_dir) + strlen(buf) > len) {
          return((char *)NULL);
        }
        rplstr(buf, x - buf, pw->pw_dir);
    }
    return(len ? buf : (char *)NULL);
}



/*----------------------------------------------------------------------
    Filter file names for strange characters

   Args:  file  -- the file name to check
 
 Result: Returns NULL if file name is OK
         Returns formatted error message if it is not
  ----*/
char *
filter_filename(file, fatal)
    char *file;
    int  *fatal;
{
#ifdef ALLOW_WEIRD
    static char illegal[] = {'\177', '\0'};
#else
    static char illegal[] = {'"', '#', '$', '%', '&', '\'','(', ')','*',
                          ',', ':', ';', '<', '=', '>', '?', '[', ']',
                          '\\', '^', '|', '\177', '\0'};
#endif
    static char error[100];
    char ill_file[MAXPATH+1], *ill_char, *ptr, e2[10];
    int i;

    for(ptr = file; *ptr == ' '; ptr++) ; /* leading spaces gone */

    while(*ptr && (unsigned char)(*ptr) >= ' ' && strindex(illegal, *ptr) == 0)
      ptr++;

    *fatal = TRUE;
    if(*ptr != '\0') {
        if(*ptr == '\n') {
            ill_char = "<newline>";
        } else if(*ptr == '\r') {
            ill_char = "<carriage return>";
        } else if(*ptr == '\t') {
    	    ill_char = "<tab>";
	    *fatal = FALSE;		/* just whitespace */
        } else if(*ptr < ' ') {
            sprintf(e2, "control-%c", *ptr + '@');
            ill_char = e2;
        } else if (*ptr == '\177') {
    	    ill_char = "<del>";
        } else {
    	    e2[0] = *ptr;
    	    e2[1] = '\0';
    	    ill_char = e2;
	    *fatal = FALSE;		/* less offensive? */
        }
	if(!*fatal){
	    strcpy(error, ill_char);
	}
        else if(ptr != file) {
            strncpy(ill_file, file, ptr - file);
            ill_file[ptr - file] = '\0';
	    sprintf(error,
		    "Character \"%s\" after \"%s\" not allowed in file name",
		    ill_char, ill_file);
        } else {
            sprintf(error,
                    "First character, \"%s\", not allowed in file name",
                    ill_char);
        }
            
        return(error);
    }

    if((i=is_writable_dir(file)) == 0 || i == 1){
	sprintf(error, "\"%s\" is a directory", file);
        return(error);
    }

    if(ps_global->restricted || ps_global->VAR_OPER_DIR){
	for(ptr = file; *ptr == ' '; ptr++) ;	/* leading spaces gone */

	if((ptr[0] == '.' && ptr[1] == '.') || srchstr(ptr, "/../")){
	    sprintf(error, "\"..\" not allowed in filename");
	    return(error);
	}
    }

    return((char *)NULL);
}


/*----------------------------------------------------------------------
    Check to see if user is allowed to read or write this folder.

   Args:  s  -- the name to check
 
 Result: Returns 1 if OK
         Returns 0 and posts an error message if access is denied
  ----*/
int
cntxt_allowed(s)
    char *s;
{
    struct variable *vars = ps_global->vars;
    int retval = 1;
    MAILSTREAM stream; /* fake stream for error message in mm_notify */

    if(ps_global->restricted
         && (strindex("./~", s[0]) || srchstr(s, "/../"))){
	stream.mailbox = s;
	mm_notify(&stream, "Restricted mode doesn't allow operation", WARN);
	retval = 0;
    }
    else if(VAR_OPER_DIR
	    && s[0] != '{' && !(s[0] == '*' && s[1] == '{')
	    && strucmp(s,ps_global->inbox_name) != 0
	    && strcmp(s, ps_global->VAR_INBOX_PATH) != 0){
	char *p, *free_this = NULL;

	p = s;
	if(strindex(s, '~')){
	    p = strindex(s, '~');
	    free_this = (char *)fs_get(strlen(p) + 200);
	    strcpy(free_this, p);
	    fnexpand(free_this, strlen(p)+200);
	    p = free_this;
	}
	else if(p[0] != '/'){  /* add home dir to relative paths */
	    free_this = p = (char *)fs_get(strlen(s)
					    + strlen(ps_global->home_dir) + 2);
	    build_path(p, ps_global->home_dir, s);
	}
	
	if(!in_dir(VAR_OPER_DIR, p)){
	    char err[200];

	    sprintf(err, "Not allowed outside of %s", VAR_OPER_DIR);
	    stream.mailbox = p;
	    mm_notify(&stream, err, WARN);
	    retval = 0;
	}
	else if(srchstr(p, "/../")){  /* check for .. in path */
	    stream.mailbox = p;
	    mm_notify(&stream, "\"..\" not allowed in name", WARN);
	    retval = 0;
	}

	if(free_this)
	  fs_give((void **)&free_this);
    }
    
    return retval;
}



#if defined(USE_QUOTAS)

/*----------------------------------------------------------------------
   This system doesn't have disk quotas.
   Return space left in disk quota on file system which given path is in.

    Args: path - Path name of file or directory on file system of concern
          over - pointer to flag that is set if the user is over quota

 Returns: If *over = 0, the number of bytes free in disk quota as per
          the soft limit.
	  If *over = 1, the number of bytes *over* quota.
          -1 is returned on an error looking up quota
           0 is returned if there is no quota

BUG:  If there's more than 2.1Gb free this function will break
  ----*/
long
disk_quota(path, over)
    char *path;
    int  *over;
{
    return(0L);
}
#endif /* USE_QUOTAS */



/*----------------------------------------------------------------------
    Read whole file into memory

  Args: filename -- path name of file to read

  Result: Returns pointer to malloced memory with the contents of the file
          or NULL

This won't work very well if the file has NULLs in it and is mostly
intended for fairly small text files.
 ----*/
char *
read_file(filename)
    char *filename;
{
    int         fd;
    struct stat statbuf;
    char       *buf;
    int         nb;

    fd = open(filename, O_RDONLY);
    if(fd < 0)
      return((char *)NULL);

    fstat(fd, &statbuf);

    buf = fs_get((size_t)statbuf.st_size + 1);

    /*
     * On some systems might have to loop here, if one read isn't guaranteed
     * to get the whole thing.
     */
    if((nb = read(fd, buf, (int)statbuf.st_size)) < 0)
      fs_give((void **)&buf);		/* NULL's buf */
    else
      buf[nb] = '\0';

    close(fd);
    return(buf);
}



/*----------------------------------------------------------------------
   Create a temporary file, the name of which we don't care about 
and that goes away when it is closed.  Just like ANSI C tmpfile.
  ----*/
FILE  *
create_tmpfile()
{
    return(tmpfile());
}



/*----------------------------------------------------------------------
     Abort with a core dump
 ----*/
void
coredump()
{
    abort();
}



/*----------------------------------------------------------------------
       Call system gethostname

  Args: hostname -- buffer to return host name in 
        size     -- Size of buffer hostname is to be returned in

 Result: returns 0 if the hostname is correctly set,
         -1 if not (and errno is set).
 ----*/
hostname(hostname,size) 
    char *hostname;
    int size;
{
    return(gethostname(hostname, size));
}



/*----------------------------------------------------------------------
       Get the current host and domain names

    Args: hostname   -- buffer to return the hostname in
          hsize      -- size of buffer above
          domainname -- buffer to return domain name in
          dsize      -- size of buffer above

  Result: The system host and domain names are returned. If the full host
          name is akbar.cac.washington.edu then the domainname is
          cac.washington.edu.

On Internet connected hosts this look up uses /etc/hosts and DNS to
figure all this out. On other less well connected machines some other
file may be read. If there is no notion of a domain name the domain
name may be left blank. On a PC where there really isn't a host name
this should return blank strings. The .pinerc will take care of
configuring the domain names. That is, this should only return the
native system's idea of what the names are if the system has such
a concept.
 ----*/
void
getdomainnames(hostname, hsize, domainname, dsize)
    char *hostname, *domainname;
    int   hsize, dsize;
{
    char           *dn, hname[MAX_ADDRESS+1];
    struct hostent *he;
    char          **alias;
    char           *maybe = NULL;

    gethostname(hname, MAX_ADDRESS);
    he = gethostbyname(hname);
    hostname[0] = '\0';

    if(he == NULL)
      strncpy(hostname, hname, hsize-1);
    else{
	/*
	 * If no dot in hostname it may be the case that there
	 * is an alias which is really the fully-qualified
	 * hostname. This could happen if the administrator has
	 * (incorrectly) put the unqualified name first in the
	 * hosts file, for example. The problem with looking for
	 * an alias with a dot is that now we're guessing, since
	 * the aliases aren't supposed to be the official hostname.
	 * We'll compromise and only use an alias if the primary
	 * name has no dot and exactly one of the aliases has a
	 * dot.
	 */
	strncpy(hostname, he->h_name, hsize-1);
	if(strindex(hostname, '.') == NULL){		/* no dot in hostname */
	    for(alias = he->h_aliases; *alias; alias++){
		if(strindex(*alias, '.') != NULL){	/* found one */
		    if(maybe){		/* oops, this is the second one */
			maybe = NULL;
			break;
		    }
		    else
		      maybe = *alias;
		}
	    }

	    if(maybe)
	      strncpy(hostname, maybe, hsize-1);
	}
    }

    hostname[hsize-1] = '\0';


    if((dn = strindex(hostname, '.')) != NULL)
      strncpy(domainname, dn+1, dsize-1);
    else
      strncpy(domainname, hostname, dsize-1);

    domainname[dsize-1] = '\0';
}



/*----------------------------------------------------------------------
       Return canonical form of host name ala c-client (UNIX version).

   Args: host      -- The host name

 Result: Canonical form, or input argument (worst case)
 ----*/
char *
canonical_name(host)
    char *host;
{
    struct hostent *hent;
    char hostname[MAILTMPLEN];
    char tmp[MAILTMPLEN];
    extern char *lcase();
                                /* domain literal is easy */
    if (host[0] == '[' && host[(strlen (host))-1] == ']')
      return host;

    strcpy (hostname,host);       /* UNIX requires lowercase */
                                /* lookup name, return canonical form */
    return (hent = gethostbyname (lcase (strcpy (tmp,host)))) ?
      hent->h_name : host;
}



/*----------------------------------------------------------------------
     This routine returns 1 if job control is available.  Note, thiis
     could be some type of fake job control.  It doesn't have to be
     real BSD-style job control.
  ----*/
have_job_control()
{
    return 1;
}


/*----------------------------------------------------------------------
    If we don't have job control, this routine is never called.
  ----*/
stop_process()
{
    SigType (*save_usr2) SIG_PROTO((int));
    
    /*
     * Since we can't respond to KOD while stopped, the process that sent 
     * the KOD is going to go read-only.  Therefore, we can safely ignore
     * any KODs that come in before we are ready to respond...
     */
    save_usr2 = signal(SIGUSR2, SIG_IGN);
    kill(0, SIGSTOP); 
    (void)signal(SIGUSR2, save_usr2);
}



/*----------------------------------------------------------------------
       Return string describing the error

   Args: errnumber -- The system error number (errno)

 Result:  long string describing the error is returned
  ----*/
char *
error_description(errnumber)
    int errnumber;
{
    static char buffer[50+1];

    if(errnumber >= 0 && errnumber < sys_nerr)
      sprintf(buffer, "%.*s", 50, sys_errlist[errnumber]);
    else
      sprintf(buffer, "Unknown error #%d", errnumber);

    return ( (char *) buffer);
}



/*----------------------------------------------------------------------
      Pull the name out of the gcos field if we have that sort of /etc/passwd

   Args: gcos_field --  The long name or GCOS field to be parsed
         logname    --  Replaces occurances of & with logname string

 Result: returns pointer to buffer with name
  ----*/
static char *
gcos_name(gcos_field, logname)
    char *logname, *gcos_field;
{
    static char fullname[MAX_FULLNAME+1];
    register char *fncp, *gcoscp, *lncp, *end;

    /* full name is all chars up to first ',' (or whole gcos, if no ',') */
    /* replace any & with logname in upper case */

    for(fncp = fullname, gcoscp= gcos_field, end = fullname + MAX_FULLNAME - 1;
        (*gcoscp != ',' && *gcoscp != '\0' && fncp != end);
	gcoscp++) {

	if(*gcoscp == '&') {
	    for(lncp = logname; *lncp; fncp++, lncp++)
		*fncp = toupper((unsigned char)(*lncp));
	} else {
	    *fncp++ = *gcoscp;
	}
    }
    
    *fncp = '\0';
    return(fullname);
}


/*----------------------------------------------------------------------
      Fill in homedir, login, and fullname for the logged in user.
      These are all pointers to static storage so need to be copied
      in the caller.

 Args: ui    -- struct pointer to pass back answers

 Result: fills in the fields
  ----*/
void
get_user_info(ui)
    struct user_info *ui;
{
    struct passwd *unix_pwd;

    unix_pwd = getpwuid(getuid());
    if(unix_pwd == NULL) {
      ui->homedir = cpystr("");
      ui->login = cpystr("");
      ui->fullname = cpystr("");
    }else {
      ui->homedir = cpystr(unix_pwd->pw_dir);
      ui->login = cpystr(unix_pwd->pw_name);
      ui->fullname = cpystr(gcos_name(unix_pwd->pw_gecos, unix_pwd->pw_name));
    }
}


/*----------------------------------------------------------------------
      Look up a userid on the local system and return rfc822 address

 Args: name  -- possible login name on local system

 Result: returns NULL or pointer to alloc'd string rfc822 address.
  ----*/
char *
local_name_lookup(name)
    char *name;
{
    struct passwd *pw = getpwnam(name);

    if(pw == NULL){
	char *p;

	for(p = name; *p; p++)
	  if(isupper((unsigned char)*p))
	    break;

	/* try changing it to all lower case */
	if(p && *p){
	    char *lcase;

	    lcase = cpystr(name);
	    for(p = lcase; *p; p++)
	      if(isupper((unsigned char)*p))
		*p = tolower((unsigned char)*p);

	    pw = getpwnam(lcase);

	    if(pw)
	      strcpy(name, lcase);

	    fs_give((void **)&lcase);
	}
    }

    if(pw == NULL)
      return((char *)NULL);

    return(cpystr(gcos_name(pw->pw_gecos, name)));
}



/*----------------------------------------------------------------------
       Call the system to change the passwd
 
It would be nice to talk to the passwd program via a pipe or ptty so the
user interface could be consistent, but we can't count on the the prompts
and responses from the passwd program to be regular so we just let the user 
type at the passwd program with some screen space, hope he doesn't scroll 
off the top and repaint when he's done.
 ----*/        
change_passwd()
{
    char cmd_buf[100];

    ClearLines(1, ps_global->ttyo->screen_rows - 1);

    MoveCursor(5, 0);
    fflush(stdout);

    PineRaw(0);
    strcpy(cmd_buf, PASSWD_PROG);
    system(cmd_buf);
    sleep(3);
    PineRaw(1);
}



/*----------------------------------------------------------------------
       Can we display this type/subtype?

   Args: type       -- the MIME type to check
         subtype    -- the MIME subtype
         params     -- parameters
	 use_viewer -- tell caller he should run external viewer cmd to view

 Result: Returns:

	 MCD_NONE	if we can't display this type at all
	 MCD_INTERNAL	if we can display it internally
	 MCD_EXTERNAL	if it can be displayed via an external viewer

 ----*/
mime_can_display(type, subtype, params)
    int       type;
    char      *subtype;
    PARAMETER *params;
{
    return((mailcap_can_display(type, subtype, params)
	      ? MCD_EXTERNAL : MCD_NONE)
	   | ((type == TYPETEXT || type == TYPEMESSAGE
	       || MIME_VCARD(type,subtype))
	        ? MCD_INTERNAL : MCD_NONE));
}



/*======================================================================
    pipe
    
    Initiate I/O to and from a process.  These functions are similar to 
    popen and pclose, but both an incoming stream and an output file are 
    provided.
   
 ====*/

#ifndef	STDIN_FILENO
#define	STDIN_FILENO	0
#endif
#ifndef	STDOUT_FILENO
#define	STDOUT_FILENO	1
#endif
#ifndef	STDERR_FILENO
#define	STDERR_FILENO	2
#endif


/*
 * Defs to help fish child's exit status out of wait(2)
 */
#ifdef	HAVE_WAIT_UNION
#define WaitType	union wait
#ifndef	WIFEXITED
#define	WIFEXITED(X)	(!(X).w_termsig)	/* child exit by choice */
#endif
#ifndef	WEXITSTATUS
#define	WEXITSTATUS(X)	(X).w_retcode		/* childs chosen exit value */
#endif
#else
#define	WaitType	int
#ifndef	WIFEXITED
#define	WIFEXITED(X)	(!((X) & 0xff))		/* low bits tell how it died */
#endif
#ifndef	WEXITSTATUS
#define	WEXITSTATUS(X)	(((X) >> 8) & 0xff)	/* high bits tell exit value */
#endif
#endif


/*
 * Global's to helpsignal handler tell us child's status has changed...
 */
short	child_signalled;
short	child_jump = 0;
jmp_buf child_state;
int	child_pid;


/*
 * Internal Protos
 */
void pipe_error_cleanup PROTO((PIPE_S **, char *, char *, char *));
void zot_pipe PROTO((PIPE_S **));
static SigType pipe_alarm SIG_PROTO((int));




/*----------------------------------------------------------------------
     Spawn a child process and optionally connect read/write pipes to it

  Args: command -- string to hand the shell
	outfile -- address of pointer containing file to receive output
	errfile -- address of pointer containing file to receive error output
	mode -- mode for type of shell, signal protection etc...
  Returns: pointer to alloc'd PIPE_S on success, NULL otherwise

  The outfile is either NULL, a pointer to a NULL value, or a pointer
  to the requested name for the output file.  In the pointer-to-NULL case
  the caller doesn't care about the name, but wants to see the pipe's
  results so we make one up.  It's up to the caller to make sure the
  free storage containing the name is cleaned up.

  Mode bits serve several purposes.
    PIPE_WRITE tells us we need to open a pipe to write the child's
	stdin.
    PIPE_READ tells us we need to open a pipe to read from the child's
	stdout/stderr.  *NOTE*  Having neither of the above set means 
	we're not setting up any pipes, just forking the child and exec'ing
	the command.  Also, this takes precedence over any named outfile.
    PIPE_STDERR means we're to tie the childs stderr to the same place
	stdout is going.  *NOTE* This only makes sense then if PIPE_READ
	or an outfile is provided.  Also, this takes precedence over any
	named errfile.
    PIPE_PROT means to protect the child from the usual nasty signals
	that might cause premature death.  Otherwise, the default signals are
	set so the child can deal with the nasty signals in its own way.     
    PIPE_NOSHELL means we're to exec the command without the aid of
	a system shell.  *NOTE* This negates the affect of PIPE_USER.
    PIPE_USER means we're to try executing the command in the user's
	shell.  Right now we only look in the environment, but that may get
	more sophisticated later.
    PIPE_RESET means we reset the terminal mode to what it was before
	we started pine and then exec the command.
 ----*/
PIPE_S *
open_system_pipe(command, outfile, errfile, mode, timeout)
    char  *command;
    char **outfile, **errfile;
    int    mode, timeout;
{
    PIPE_S *syspipe = NULL;
    char    shellpath[32], *shell;
    int     p[2], oparentd = -1, ochildd = -1, iparentd = -1, ichildd = -1;

    dprint(5, (debugfile, "Opening pipe: \"%s\" (%s%s%s%s%s%s)\n", command,
	       (mode & PIPE_WRITE)   ? "W":"", (mode & PIPE_READ)  ? "R":"",
	       (mode & PIPE_NOSHELL) ? "N":"", (mode & PIPE_PROT)  ? "P":"",
	       (mode & PIPE_USER)    ? "U":"", (mode & PIPE_RESET) ? "T":""));

    syspipe = (PIPE_S *)fs_get(sizeof(PIPE_S));
    memset(syspipe, 0, sizeof(PIPE_S));

    /*
     * If we're not using the shell's command parsing smarts, build
     * argv by hand...
     */
    if(mode & PIPE_NOSHELL){
	char   **ap, *p;
	size_t   n;

	/* parse the arguments into argv */
	for(p = command; *p && isspace((unsigned char)(*p)); p++)
	  ;					/* swallow leading ws */

	if(*p){
	    syspipe->args = cpystr(p);
	}
	else{
	    pipe_error_cleanup(&syspipe, "<null>", "execute",
			       "No command name found");
	    return(NULL);
	}

	for(p = syspipe->args, n = 2; *p; p++)	/* count the args */
	  if(isspace((unsigned char)(*p))
	     && *(p+1) && !isspace((unsigned char)(*(p+1))))
	    n++;

	syspipe->argv = ap = (char **)fs_get(n * sizeof(char *));
	memset(syspipe->argv, 0, n * sizeof(char *));

	for(p = syspipe->args; *p; ){		/* collect args */
	    while(*p && isspace((unsigned char)(*p)))
	      *p++ = '\0';

	    *ap++ = (*p) ? p : NULL;
	    while(*p && !isspace((unsigned char)(*p)))
	      p++;
	}

	/* make sure argv[0] exists in $PATH */
	if(can_access_in_path(getenv("PATH"), syspipe->argv[0],
			      EXECUTE_ACCESS) < 0){
	    pipe_error_cleanup(&syspipe, syspipe->argv[0], "access",
			       error_description(errno));
	    return(NULL);
	}
    }

    /* fill in any output filenames */
    if(!(mode & PIPE_READ)){
	if(outfile && !*outfile)
	  *outfile = temp_nam(NULL, "pine_p");	/* asked for, but not named? */

	if(errfile && !*errfile)
	  *errfile = temp_nam(NULL, "pine_p");	/* ditto */
    }

    /* create pipes */
    if(mode & (PIPE_WRITE | PIPE_READ)){
	if(mode & PIPE_WRITE){
	    pipe(p);				/* alloc pipe to write child */
	    oparentd = p[STDOUT_FILENO];
	    ichildd  = p[STDIN_FILENO];
	}

	if(mode & PIPE_READ){
	    pipe(p);				/* alloc pipe to read child */
	    iparentd = p[STDIN_FILENO];
	    ochildd  = p[STDOUT_FILENO];
	}
    }
    else if(!(mode & PIPE_SILENT)){
	flush_status_messages(0);		/* just clean up display */
	ClearScreen();
	fflush(stdout);
    }

    if((syspipe->mode = mode) & PIPE_RESET)
      PineRaw(0);

#ifdef	SIGCHLD
    /*
     * Prepare for demise of child.  Use SIGCHLD if it's available so
     * we can do useful things, like keep the IMAP stream alive, while
     * we're waiting on the child.
     */
    child_signalled = child_jump = 0;
#endif

    if((syspipe->pid = vfork()) == 0){
 	/* reset child's handlers in requested fashion... */
	(void)signal(SIGINT,  (mode & PIPE_PROT) ? SIG_IGN : SIG_DFL);
	(void)signal(SIGQUIT, (mode & PIPE_PROT) ? SIG_IGN : SIG_DFL);
	(void)signal(SIGHUP,  (mode & PIPE_PROT) ? SIG_IGN : SIG_DFL);
#ifdef	SIGCHLD
	(void) signal(SIGCHLD,  SIG_DFL);
#endif

	/* if parent isn't reading, and we have a filename to write */
	if(!(mode & PIPE_READ) && outfile){	/* connect output to file */
	    int output = creat(*outfile, 0600);
	    dup2(output, STDOUT_FILENO);
	    if(mode & PIPE_STDERR)
	      dup2(output, STDERR_FILENO);
	    else if(errfile)
	      dup2(creat(*errfile, 0600), STDERR_FILENO);
	}

	if(mode & PIPE_WRITE){			/* connect process input */
	    close(oparentd);
	    dup2(ichildd, STDIN_FILENO);	/* tie stdin to pipe */
	    close(ichildd);
	}

	if(mode & PIPE_READ){			/* connect process output */
	    close(iparentd);
	    dup2(ochildd, STDOUT_FILENO);	/* tie std{out,err} to pipe */
	    if(mode & PIPE_STDERR)
	      dup2(ochildd, STDERR_FILENO);
	    else if(errfile)
	      dup2(creat(*errfile, 0600), STDERR_FILENO);

	    close(ochildd);
	}

	if(mode & PIPE_NOSHELL){
	    execvp(syspipe->argv[0], syspipe->argv);
	}
	else{
	    if(mode & PIPE_USER){
		char *env, *sh;
		if((env = getenv("SHELL")) && (sh = strrchr(env, '/'))){
		    shell = sh + 1;
		    strcpy(shellpath, env);
		}
		else{
		    shell = "csh";
		    strcpy(shellpath, "/bin/csh");
		}
	    }
	    else{
		shell = "sh";
		strcpy(shellpath, "/bin/sh");
	    }

	    execl(shellpath, shell, command ? "-c" : 0, command, 0);
	}

	fprintf(stderr, "Can't exec %s\nReason: %s",
		command, error_description(errno));
	_exit(-1);
    }

    if((child_pid = syspipe->pid) > 0){
	syspipe->isig = signal(SIGINT,  SIG_IGN); /* Reset handlers to make */
	syspipe->qsig = signal(SIGQUIT, SIG_IGN); /* sure we don't come to  */
	syspipe->hsig = signal(SIGHUP,  SIG_IGN); /* a premature end...     */
	if((syspipe->timeout = timeout) != 0){
	    syspipe->alrm      = signal(SIGALRM,  pipe_alarm);
	    syspipe->old_timeo = alarm(timeout);
	}

	if(mode & PIPE_WRITE){
	    close(ichildd);
	    if(mode & PIPE_DESC)
	      syspipe->out.d = oparentd;
	    else
	      syspipe->out.f = fdopen(oparentd, "w");
	}

	if(mode & PIPE_READ){
	    close(ochildd);
	    if(mode & PIPE_DESC)
	      syspipe->in.d = iparentd;
	    else
	      syspipe->in.f = fdopen(iparentd, "r");
	}

	dprint(5, (debugfile, "PID: %d, COMMAND: %s\n",syspipe->pid,command));
    }
    else{
	if(mode & (PIPE_WRITE | PIPE_READ)){
	    if(mode & PIPE_WRITE){
		close(oparentd);
		close(ichildd);
	    }

	    if(mode & PIPE_READ){
		close(iparentd);
		close(ochildd);
	    }
	}
	else if(!(mode & PIPE_SILENT)){
	    ClearScreen();
	    ps_global->mangled_screen = 1;
	}

	if(mode & PIPE_RESET)
	  PineRaw(1);

#ifdef	SIGCHLD
	(void) signal(SIGCHLD,  SIG_DFL);
#endif
	if(outfile)
	  fs_give((void **) outfile);

	pipe_error_cleanup(&syspipe, command, "fork",error_description(errno));
    }

    return(syspipe);
}



/*----------------------------------------------------------------------
    Write appropriate error messages and cleanup after pipe error

  Args: syspipe -- address of pointer to struct to clean up
	cmd -- command we were trying to exec
	op -- operation leading up to the exec
	res -- result of that operation

 ----*/
void
pipe_error_cleanup(syspipe, cmd, op, res)
    PIPE_S **syspipe;
    char    *cmd, *op, *res;
{
    q_status_message3(SM_ORDER, 3, 3, "Pipe can't %s \"%.20s\": %s",
		      op, cmd, res);
    dprint(1, (debugfile, "* * PIPE CAN'T %s(%s): %s\n", op, cmd, res));
    zot_pipe(syspipe);
}



/*----------------------------------------------------------------------
    Free resources associated with the given pipe struct

  Args: syspipe -- address of pointer to struct to clean up

 ----*/
void
zot_pipe(syspipe)
    PIPE_S **syspipe;
{
    if((*syspipe)->args)
      fs_give((void **) &(*syspipe)->args);

    if((*syspipe)->argv)
      fs_give((void **) &(*syspipe)->argv);

    if((*syspipe)->tmp)
      fs_give((void **) &(*syspipe)->tmp);

    fs_give((void **)syspipe);
}



/*----------------------------------------------------------------------
    Close pipe previously allocated and wait for child's death

  Args: syspipe -- address of pointer to struct returned by open_system_pipe
  Returns: returns exit status of child or -1 if invalid syspipe
 ----*/
int
close_system_pipe(syspipe)
    PIPE_S **syspipe;
{
    WaitType stat;
    int	     status;

    if(!(syspipe && *syspipe))
      return(-1);

    if(((*syspipe)->mode) & PIPE_WRITE){
	if(((*syspipe)->mode) & PIPE_DESC){
	    if((*syspipe)->out.d >= 0)
	      close((*syspipe)->out.d);
	}
	else if((*syspipe)->out.f)
	  fclose((*syspipe)->out.f);
    }

    if(((*syspipe)->mode) & PIPE_READ){
	if(((*syspipe)->mode) & PIPE_DESC){
	    if((*syspipe)->in.d >= 0)
	      close((*syspipe)->in.d);
	}
	else if((*syspipe)->in.f)
	  fclose((*syspipe)->in.f);
    }

#ifdef	SIGCHLD
    {
	SigType (*alarm_sig)();
	int	old_cue = F_ON(F_SHOW_DELAY_CUE, ps_global);

	/*
	 * remember the current SIGALRM handler, and make sure it's
	 * installed when we're finished just in case the longjmp
	 * out of the SIGCHLD handler caused sleep() to lose it.
	 * Don't pay any attention to that man behind the curtain.
	 */
	alarm_sig = signal(SIGALRM, SIG_IGN);
	F_SET(F_SHOW_DELAY_CUE, ps_global, 0);
	ps_global->noshow_timeout = 1;
	while(!child_signalled){
	    /* wake up and prod server */
	    new_mail(0, 2, ((*syspipe)->mode & PIPE_RESET)
			      ? NM_NONE : NM_DEFER_SORT);

	    if(!child_signalled){
		if(setjmp(child_state) == 0){
		    child_jump = 1;	/* prepare to wake up */
		    sleep(600);		/* give it 5mins to happend */
		}
		else
		  our_sigunblock(SIGCHLD);
	    }

	    child_jump = 0;
	}

	ps_global->noshow_timeout = 0;
	F_SET(F_SHOW_DELAY_CUE, ps_global, old_cue);
	(void) signal(SIGALRM, alarm_sig);
    }
#endif

    /*
     * Call c-client's pid reaper to wait() on the demise of our child,
     * then fish out its exit status...
     */
    grim_pid_reap_status((*syspipe)->pid, 0, &stat);
    status = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;

    /*
     * restore original handlers...
     */
    (void)signal(SIGINT,  (*syspipe)->isig);
    (void)signal(SIGHUP,  (*syspipe)->hsig);
    (void)signal(SIGQUIT, (*syspipe)->qsig);

    if((*syspipe)->timeout){
	(void)signal(SIGALRM, (*syspipe)->alrm);
	alarm((*syspipe)->old_timeo);
	child_pid = 0;
    }

    if((*syspipe)->mode & PIPE_RESET)		/* restore our tty modes */
      PineRaw(1);

    if(!((*syspipe)->mode & (PIPE_WRITE | PIPE_READ | PIPE_SILENT))){
	ClearScreen();				/* No I/O to forked child */
	ps_global->mangled_screen = 1;
    }

    zot_pipe(syspipe);

    return(status);
}



static SigType
pipe_alarm SIG_PROTO((int sig))
{
    if(child_pid)
      kill(child_pid, SIGINT);
}

/*======================================================================
    post_reap
    
    Manage exit status collection of a child spawned to handle posting
 ====*/



#if	defined(BACKGROUND_POST) && defined(SIGCHLD)
/*----------------------------------------------------------------------
    Check to see if we have any posting processes to clean up after

  Args: none
  Returns: any finished posting process reaped
 ----*/
post_reap()
{
    WaitType stat;
    int	     r;

    if(ps_global->post && ps_global->post->pid){
	r = waitpid(ps_global->post->pid, &stat, WNOHANG);
	if(r == ps_global->post->pid){
	    ps_global->post->status = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
	    ps_global->post->pid = 0;
	    return(1);
	}
	else if(r < 0 && errno != EINTR){ /* pid's become bogus?? */
	    fs_give((void **) &ps_global->post);
	}
    }

    return(0);
}
#endif

/*----------------------------------------------------------------------
    Routines used to hand off messages to local agents for sending/posting

 The two exported routines are:

    1) smtp_command()  -- used to get local transport agent to invoke
    2) post_handoff()  -- used to pass messages to local posting agent

 ----*/



/*
 * Protos for "sendmail" internal functions
 */
static char *mta_parse_post PROTO((METAENV *, BODY *, char *, char *));
static long  pine_pipe_soutr_nl PROTO((void *, char *));



/* ----------------------------------------------------------------------
   Figure out command to start local SMTP agent

  Args: errbuf   -- buffer for reporting errors (assumed non-NULL)

  Returns an alloc'd copy of the local SMTP agent invocation or NULL

  ----*/
char *
smtp_command(errbuf)
    char *errbuf;
{
#if	defined(SENDMAIL) && defined(SENDMAILFLAGS)
    char tmp[256];

    sprintf(tmp, "%s %s", SENDMAIL, SENDMAILFLAGS);
    return(cpystr(tmp));
#else
    strcpy(errbuf, "No default posting command.");
    return(NULL);
#endif
}



/*----------------------------------------------------------------------
   Hand off given message to local posting agent

  Args: envelope -- The envelope for the BCC and debugging
        header   -- The text of the message header
        errbuf   -- buffer for reporting errors (assumed non-NULL)
     
   ----*/
int
mta_handoff(header, body, errbuf)
    METAENV    *header;
    BODY       *body;
    char       *errbuf;
{
    char cmd_buf[256], *cmd = NULL;

    /*
     * A bit of complicated policy implemented here.
     * There are two posting variables sendmail-path and smtp-server.
     * Precedence is in that order.
     * They can be set one of 4 ways: fixed, command-line, user, or globally.
     * Precedence is in that order.
     * Said differently, the order goes something like what's below.
     * 
     * NOTE: the fixed/command-line/user precendence handling is also
     *	     indicated by what's pointed to by ps_global->VAR_*, but since
     *	     that also includes the global defaults, it's not sufficient.
     */

    if(ps_global->FIX_SENDMAIL_PATH
       && ps_global->FIX_SENDMAIL_PATH[0]){
	cmd = ps_global->FIX_SENDMAIL_PATH;
    }
    else if(!(ps_global->FIX_SMTP_SERVER
	      && ps_global->FIX_SMTP_SERVER[0])){
	if(ps_global->COM_SENDMAIL_PATH
	   && ps_global->COM_SENDMAIL_PATH[0]){
	    cmd = ps_global->COM_SENDMAIL_PATH;
	}
	else if(!(ps_global->COM_SMTP_SERVER
		  && ps_global->COM_SMTP_SERVER[0])){
	    if(ps_global->USR_SENDMAIL_PATH
	       && ps_global->USR_SENDMAIL_PATH[0]){
		cmd = ps_global->USR_SENDMAIL_PATH;
	    }
	    else if(!(ps_global->USR_SMTP_SERVER
		      && ps_global->USR_SMTP_SERVER[0])){
		if(ps_global->GLO_SENDMAIL_PATH
		   && ps_global->GLO_SENDMAIL_PATH[0]){
		    cmd = ps_global->GLO_SENDMAIL_PATH;
		}
#ifdef	DF_SENDMAIL_PATH
		/*
		 * This defines the default method of posting.  So,
		 * unless we're told otherwise use it...
		 */
		else if(!(ps_global->GLO_SMTP_SERVER
			  && ps_global->GLO_SMTP_SERVER[0])){
		    strcpy(cmd = cmd_buf, DF_SENDMAIL_PATH);
		}
#endif
	    }
	}
    }

    *errbuf = '\0';
    if(cmd){
	dprint(4, (debugfile, "call_mailer via cmd: %s\n", cmd));

	(void) mta_parse_post(header, body, cmd, errbuf);
	return(1);
    }
    else
      return(0);
}



/*----------------------------------------------------------------------
   Hand off given message to local posting agent

  Args: envelope -- The envelope for the BCC and debugging
        header   -- The text of the message header
        errbuf   -- buffer for reporting errors (assumed non-NULL)
     
  Fork off mailer process and pipe the message into it
  Called to post news via Inews when NNTP is unavailable
  
   ----*/
char *
post_handoff(header, body, errbuf)
    METAENV    *header;
    BODY       *body;
    char       *errbuf;
{
    char *err = NULL;
#ifdef	SENDNEWS
    char *s;

    if(s = strstr(header->env->date," (")) /* fix the date format for news */
      *s = '\0';

    if(err = mta_parse_post(header, body, SENDNEWS, errbuf))
      sprintf(err = errbuf, "News not posted: \"%s\": %s", SENDNEWS, err);

    if(s)
      *s = ' ';				/* restore the date */

#else /* !SENDNEWS */  /* this is the default case */
    sprintf(err = errbuf, "Can't post, NNTP-server must be defined!");
#endif /* !SENDNEWS */
    return(err);
}



/*----------------------------------------------------------------------
   Hand off message to local MTA; it parses recipients from 822 header

  Args: header -- struct containing header data
        body  -- struct containing message body data
	cmd -- command to use for handoff (%s says where file should go)
	errs -- pointer to buf to hold errors

   ----*/
static char *
mta_parse_post(header, body, cmd, errs)
    METAENV *header;
    BODY    *body;
    char    *cmd;
    char    *errs;
{
    char   *result = NULL;
    PIPE_S *pipe;

    dprint(1, (debugfile, "=== mta_parse_post(%s) ===\n", cmd));

    if(pipe = open_system_pipe(cmd, &result, NULL,
		 PIPE_STDERR|PIPE_WRITE|PIPE_PROT|PIPE_NOSHELL|PIPE_DESC, 0)){
	if(!pine_rfc822_output(header, body, pine_pipe_soutr_nl,
			       (TCPSTREAM *) pipe))
	  strcpy(errs, "Error posting.");

	if(close_system_pipe(&pipe) && !*errs){
	    sprintf(errs, "Posting program %s returned error", cmd);
	    if(result)
	      display_output_file(result, "POSTING ERRORS", errs, 1);
	}
    }
    else
      sprintf(errs, "Error running \"%s\"", cmd);

    if(result){
	unlink(result);
	fs_give((void **)&result);
    }

    return(*errs ? errs : NULL);
}


/* 
 * pine_pipe_soutr - Replacement for tcp_soutr that writes one of our
 *		     pipes rather than a tcp stream
 */
static long
pine_pipe_soutr_nl (stream,s)
     void *stream;
     char *s;
{
    long    rv = T;
    char   *p;
    size_t  n;

    while(*s && rv){
	if(n = (p = strstr(s, "\015\012")) ? p - s : strlen(s))
	  while((rv = write(((PIPE_S *)stream)->out.d, s, n)) != n)
	    if(rv < 0){
		if(errno != EINTR){
		    rv = 0;
		    break;
		}
	    }
	    else{
		s += rv;
		n -= rv;
	    }

	if(p && rv){
	    s = p + 2;			/* write UNIX EOL */
	    while((rv = write(((PIPE_S *)stream)->out.d,"\n",1)) != 1)
	      if(rv < 0 && errno != EINTR){
		  rv = 0;
		  break;
	      }
	}
	else
	  break;
    }

    return(rv);
}

/* ----------------------------------------------------------------------
   Execute the given mailcap command

  Args: cmd           -- the command to execute
	image_file    -- the file the data is in
	needsterminal -- does this command want to take over the terminal?
  ----*/
void
exec_mailcap_cmd(cmd, image_file, needsterminal)
char *cmd;
char *image_file;
int   needsterminal;
{
    char   *command = NULL,
	   *result_file = NULL,
	   *p;
    char  **r_file_h;
    PIPE_S *syspipe;
    int     mode;

    p = command = (char *)fs_get((32 + strlen(cmd) + (2*strlen(image_file)))
			     * sizeof(char));
    if(!needsterminal)  /* put in background if it doesn't need terminal */
      *p++ = '(';
    sprintf(p, "%s ; rm -f %s", cmd, image_file);
    p += strlen(p);
    if(!needsterminal){
	*p++ = ')';
	*p++ = ' ';
	*p++ = '&';
    }
    *p++ = '\n';
    *p   = '\0';
    dprint(9, (debugfile, "exec_mailcap_cmd: command=%s\n", command));

    mode = PIPE_RESET;
    if(needsterminal == 1)
      r_file_h = NULL;
    else{
	mode       |= PIPE_WRITE | PIPE_STDERR;
	result_file = temp_nam(NULL, "pine_cmd");
	r_file_h    = &result_file;
    }

    if(syspipe = open_system_pipe(command, r_file_h, NULL, mode, 0)){
	close_system_pipe(&syspipe);
	if(needsterminal == 1)
	  q_status_message(SM_ORDER, 0, 4, "VIEWER command completed");
	else if(needsterminal == 2)
	  display_output_file(result_file, "VIEWER", " command result", 1);
	else
	  display_output_file(result_file, "VIEWER", " command launched", 1);
    }
    else
      q_status_message1(SM_ORDER, 3, 4, "Cannot spawn command : %s", cmd);

    fs_give((void **)&command);
    if(result_file)
      fs_give((void **)&result_file);
}


/* ----------------------------------------------------------------------
   Execute the given mailcap test= cmd

  Args: cmd -- command to execute
  Returns exit status
  
  ----*/
int
exec_mailcap_test_cmd(cmd)
    char *cmd;
{
    PIPE_S *syspipe;

    return((syspipe = open_system_pipe(cmd, NULL, NULL, PIPE_SILENT, 0))
	     ? close_system_pipe(&syspipe) : -1);
}



/*======================================================================
    print routines
   
    Functions having to do with printing on paper and forking of spoolers

    In general one calls open_printer() to start printing. One of
    the little print functions to send a line or string, and then
    call print_end() when complete. This takes care of forking off a spooler
    and piping the stuff down it. No handles or anything here because there's
    only one printer open at a time.

 ====*/



static char *trailer;  /* so both open and close_printer can see it */

/*----------------------------------------------------------------------
       Open the printer

  Args: desc -- Description of item to print. Should have one trailing blank.

  Return value: < 0 is a failure.
		0 a success.

This does most of the work of popen so we can save the standard output of the
command we execute and send it back to the user.
  ----*/
int
open_printer(desc)
    char     *desc;
{
    char command[201], prompt[200];
    int  cmd, rc, just_one;
    char *p, *init, *nick;
    char aname[100];
    char *printer;
    int	 done = 0, i, lastprinter, cur_printer = 0;
    HelpType help;
    char   **list;
    static ESCKEY_S ekey[] = {
	{'y', 'y', "Y", "Yes"},
	{'n', 'n', "N", "No"},
	{ctrl('P'), 10, "^P", "Prev Printer"},
	{ctrl('N'), 11, "^N", "Next Printer"},
	{-2,   0,   NULL, NULL},
	{'c', 'c', "C", "CustomPrint"},
	{KEY_UP,    10, "", ""},
	{KEY_DOWN,  11, "", ""},
	{-1, 0, NULL, NULL}};
#define PREV_KEY   2
#define NEXT_KEY   3
#define CUSTOM_KEY 5
#define UP_KEY     6
#define DOWN_KEY   7

    trailer      = NULL;
    init         = NULL;
    nick         = NULL;
    command[200] = '\0';

    if(ps_global->VAR_PRINTER == NULL){
        q_status_message(SM_ORDER | SM_DING, 3, 5,
	"No printer has been chosen.  Use SETUP on main menu to make choice.");
	return(-1);
    }

    /* Is there just one print command available? */
    just_one = (ps_global->printer_category!=3&&ps_global->printer_category!=2)
	       || (ps_global->printer_category == 2
		   && !(ps_global->VAR_STANDARD_PRINTER
			&& ps_global->VAR_STANDARD_PRINTER[0]
			&& ps_global->VAR_STANDARD_PRINTER[1]))
	       || (ps_global->printer_category == 3
		   && !(ps_global->VAR_PERSONAL_PRINT_COMMAND
			&& ps_global->VAR_PERSONAL_PRINT_COMMAND[0]
			&& ps_global->VAR_PERSONAL_PRINT_COMMAND[1]));

    if(F_ON(F_CUSTOM_PRINT, ps_global))
      ekey[CUSTOM_KEY].ch = 'c'; /* turn this key on */
    else
      ekey[CUSTOM_KEY].ch = -2;  /* turn this key off */

    if(just_one){
	ekey[PREV_KEY].ch = -2;  /* turn these keys off */
	ekey[NEXT_KEY].ch = -2;
	ekey[UP_KEY].ch   = -2;
	ekey[DOWN_KEY].ch = -2;
    }
    else{
	ekey[PREV_KEY].ch = ctrl('P'); /* turn these keys on */
	ekey[NEXT_KEY].ch = ctrl('N');
	ekey[UP_KEY].ch   = KEY_UP;
	ekey[DOWN_KEY].ch = KEY_DOWN;
	/*
	 * count how many printers in list and find the default in the list
	 */
	if(ps_global->printer_category == 2)
	  list = ps_global->VAR_STANDARD_PRINTER;
	else
	  list = ps_global->VAR_PERSONAL_PRINT_COMMAND;

	for(i = 0; list[i]; i++)
	  if(strcmp(ps_global->VAR_PRINTER, list[i]) == 0)
	    cur_printer = i;
	
	lastprinter = i - 1;
    }

    help = NO_HELP;
    ps_global->mangled_footer = 1;

    while(!done){
	if(init)
	  fs_give((void **)&init);

	if(trailer)
	  fs_give((void **)&trailer);

	if(just_one)
	  printer = ps_global->VAR_PRINTER;
	else
	  printer = list[cur_printer];

	parse_printer(printer, &nick, &p, &init, &trailer, NULL, NULL);
	strncpy(command, p, 200);
	fs_give((void **)&p);
	sprintf(prompt, "Print %.50s%susing \"%.50s\" ? ",
		desc ? desc : "",
		(desc && *desc && desc[strlen(desc) - 1] != ' ') ? " " : "",
		*nick ? nick : command);

	fs_give((void **)&nick);
	
	cmd = radio_buttons(prompt, -FOOTER_ROWS(ps_global),
				 ekey, 'y', 'x', help, RB_NORM);
	
	switch(cmd){
	  case 'y':
	    q_status_message1(SM_ORDER, 0, 9,
		"Printing with command \"%s\"", command);
	    done++;
	    break;

	  case 10:
	    cur_printer = (cur_printer>0)
				? (cur_printer-1)
				: lastprinter;
	    break;

	  case 11:
	    cur_printer = (cur_printer<lastprinter)
				? (cur_printer+1)
				: 0;
	    break;

	  case 'n':
	  case 'x':
	    done++;
	    break;

	  case 'c':
	    done++;
	    break;

	  default:
	    break;
	}
    }

    if(cmd == 'c'){
	if(init)
	  fs_give((void **)&init);

	if(trailer)
	  fs_give((void **)&trailer);

	sprintf(prompt, "Enter custom command : ");
	command[0] = '\0';
	rc = 1;
	help = NO_HELP;
	while(rc){
	    int flags = OE_APPEND_CURRENT;

	    rc = optionally_enter(command, -FOOTER_ROWS(ps_global), 0,
		200, prompt, NULL, help, &flags);
	    
	    if(rc == 1){
		cmd = 'x';
		rc = 0;
	    }
	    else if(rc == 3)
	      help = (help == NO_HELP) ? h_custom_print : NO_HELP;
	    else if(rc == 0){
		removing_trailing_white_space(command);
		removing_leading_white_space(command);
		q_status_message1(SM_ORDER, 0, 9,
		    "Printing with command \"%s\"", command);
	    }
	}
    }

    if(cmd == 'x' || cmd == 'n'){
	q_status_message(SM_ORDER, 0, 2, "Print cancelled");
	if(init)
	  fs_give((void **)&init);

	if(trailer)
	  fs_give((void **)&trailer);

	return(-1);
    }

    display_message('x');

    ps_global->print = (PRINT_S *)fs_get(sizeof(PRINT_S));
    memset(ps_global->print, 0, sizeof(PRINT_S));

    strcat(strcpy(aname, ANSI_PRINTER), "-no-formfeed");
    if(strucmp(command, ANSI_PRINTER) == 0
       || strucmp(command, aname) == 0){
        /*----------- Printer attached to ansi device ---------*/
        q_status_message(SM_ORDER, 0, 9,
	    "Printing to attached desktop printer...");
        display_message('x');
	xonxoff_proc(1);			/* make sure XON/XOFF used */
	crlf_proc(1);				/* AND LF->CR xlation */
        fputs("\033[5i", stdout);
        ps_global->print->fp = stdout;
        if(strucmp(command, ANSI_PRINTER) == 0){
	    /* put formfeed at the end of the trailer string */
	    if(trailer){
		int len = strlen(trailer);

		fs_resize((void **)&trailer, len+2);
		trailer[len] = '\f';
		trailer[len+1] = '\0';
	    }
	    else
	      trailer = cpystr("\f");
	}
    }
    else{
        /*----------- Print by forking off a UNIX command ------------*/
        dprint(4, (debugfile, "Printing using command \"%s\"\n", command));
	ps_global->print->result = temp_nam(NULL, "pine_prt");
	if(ps_global->print->pipe = open_system_pipe(command,
					 &ps_global->print->result, NULL,
					 PIPE_WRITE | PIPE_STDERR, 0)){
	    ps_global->print->fp = ps_global->print->pipe->out.f;
	}
	else{
	    fs_give((void **)&ps_global->print->result);
            q_status_message1(SM_ORDER | SM_DING, 3, 4,
			      "Error opening printer: %s",
                              error_description(errno));
            dprint(2, (debugfile, "Error popening printer \"%s\"\n",
                      error_description(errno)));
	    if(init)
	      fs_give((void **)&init);

	    if(trailer)
	      fs_give((void **)&trailer);
	    
	    return(-1);
        }
    }

    ps_global->print->err = 0;
    if(init){
	if(*init)
	  fputs(init, ps_global->print->fp);

	fs_give((void **)&init);
    }

    return(0);
}



/*----------------------------------------------------------------------
     Close printer
  
  If we're piping to a spooler close down the pipe and wait for the process
to finish. If we're sending to an attached printer send the escape sequence.
Also let the user know the result of the print
 ----*/
void
close_printer()
{
    if(trailer){
	if(*trailer)
	  fputs(trailer, ps_global->print->fp);

	fs_give((void **)&trailer);
    }

    if(ps_global->print->fp == stdout) {
        fputs("\033[4i", stdout);
        fflush(stdout);
	if(F_OFF(F_PRESERVE_START_STOP, ps_global))
	  xonxoff_proc(0);			/* turn off XON/XOFF */

	crlf_proc(0);				/* turn off CF->LF xlantion */
    } else {
	(void) close_system_pipe(&ps_global->print->pipe);
	display_output_file(ps_global->print->result, "PRINT", NULL, 1);
	fs_give((void **)&ps_global->print->result);
    }

    fs_give((void **)&ps_global->print);

    q_status_message(SM_ASYNC, 0, 3, "Print command completed");
    display_message('x');
}



/*----------------------------------------------------------------------
     Print a single character

  Args: c -- char to print
  Returns: 1 on success, 0 on ps_global->print->err
 ----*/
int
print_char(c)
    int c;
{
    if(!ps_global->print->err && putc(c, ps_global->print->fp) == EOF)
      ps_global->print->err = 1;

    return(!ps_global->print->err);
}



/*----------------------------------------------------------------------
     Send a line of text to the printer

  Args:  line -- Text to print

  ----*/
    
void
print_text(line)
    char *line;
{
    if(!ps_global->print->err && fputs(line, ps_global->print->fp) == EOF)
      ps_global->print->err = 1;
}



/*----------------------------------------------------------------------
      printf style formatting with one arg for printer

 Args: line -- The printf control string
       a1   -- The 1st argument for printf
 ----*/
void
print_text1(line, a1)
    char *line, *a1;
{
    if(!ps_global->print->err
       && fprintf(ps_global->print->fp, line, a1) < 0)
      ps_global->print->err = 1;
}



/*----------------------------------------------------------------------
      printf style formatting with one arg for printer

 Args: line -- The printf control string
       a1   -- The 1st argument for printf
       a2   -- The 2nd argument for printf
 ----*/
void
print_text2(line, a1, a2)
    char *line, *a1, *a2;
{
    if(!ps_global->print->err
       && fprintf(ps_global->print->fp, line, a1, a2) < 0)
      ps_global->print->err = 1;
}



/*----------------------------------------------------------------------
      printf style formatting with one arg for printer

 Args: line -- The printf control string
       a1   -- The 1st argument for printf
       a2   -- The 2nd argument for printf
       a3   -- The 3rd argument for printf
 ----*/
void
print_text3(line, a1, a2, a3)
    char *line, *a1, *a2, *a3;
{
    if(!ps_global->print->err
       && fprintf(ps_global->print->fp, line, a1, a2, a3) < 0)
      ps_global->print->err = 1;
}

#ifdef DEBUG
/*----------------------------------------------------------------------
     Initialize debugging - open the debug log file

  Args: none

 Result: opens the debug logfile for dprints

   Opens the file "~/.pine-debug1. Also maintains .pine-debug[2-4]
   by renaming them each time so the last 4 sessions are saved.
  ----*/
void
init_debug()
{
    char nbuf[5];
    char newfname[MAXPATH+1], filename[MAXPATH+1];
    int i, fd;

    if(!(debug || ps_global->debug_imap))
      return;

    for(i = ps_global->debug_nfiles - 1; i > 0; i--){
        build_path(filename, ps_global->home_dir, DEBUGFILE);
        strcpy(newfname, filename);
        sprintf(nbuf, "%d", i);
        strcat(filename, nbuf);
        sprintf(nbuf, "%d", i+1);
        strcat(newfname, nbuf);
        (void)rename_file(filename, newfname);
    }

    build_path(filename, ps_global->home_dir, DEBUGFILE);
    strcat(filename, "1");

    debugfile = NULL;
    if((fd = open(filename, O_TRUNC|O_RDWR|O_CREAT, 0600)) >= 0)
      debugfile = fdopen(fd, "w+");

    if(debugfile != NULL){
	time_t now = time((time_t *)0);
	if(ps_global->debug_flush)
	  setbuf(debugfile, NULL);

	if(ps_global->debug_nfiles == 0){
	    /*
	     * If no debug files are asked for, make filename a tempfile
	     * to be used for a record should pine later crash...
	     */
	    if(debug < 9 && !ps_global->debug_flush && ps_global->debug_imap<4)
	      unlink(filename);
	}

	dprint(0, (debugfile,
  "Debug output of the Pine program (debug=%d debug_imap=%d). Version %s\n%s\n",
	       debug, ps_global->debug_imap, pine_version, ctime(&now)));
    }
}


/*----------------------------------------------------------------------
     Try to save the debug file if we crash in a controlled way

  Args: dfile:  pointer to open debug file

 Result: tries to move the appropriate .pine-debugx file to .pine-crash

   Looks through the four .pine-debug files hunting for the one that is
   associated with this pine, and then renames it.
  ----*/
void
save_debug_on_crash(dfile)
FILE *dfile;
{
    char nbuf[5], crashfile[MAXPATH+1], filename[MAXPATH+1];
    int i;
    struct stat dbuf, tbuf;
    time_t now = time((time_t *)0);

    if(!(dfile && fstat(fileno(dfile), &dbuf) != 0))
      return;

    fprintf(dfile, "\nsave_debug_on_crash: Version %s: debug level %d\n",
	pine_version, debug);
    fprintf(dfile, "\n                   : %s\n", ctime(&now));

    build_path(crashfile, ps_global->home_dir, ".pine-crash");

    fprintf(dfile, "\nAttempting to save debug file to %s\n", crashfile);
    fprintf(stderr,
	"\n\n       Attempting to save debug file to %s\n\n", crashfile);

    /* Blat out last n keystrokes */
    fputs("========== Latest keystrokes ==========\n", dfile);
    while((i = key_playback(0)) != -1)
      fprintf(dfile, "\t%s\t(0x%04.4x)\n", pretty_command(i), i);

    /* look for existing debug file */
    for(i = 1; i <= ps_global->debug_nfiles; i++){
	build_path(filename, ps_global->home_dir, DEBUGFILE);
	sprintf(nbuf, "%d", i);
	strcat(filename, nbuf);
	if(stat(filename, &tbuf) != 0)
	  continue;

	/* This must be the current debug file */
	if(tbuf.st_dev == dbuf.st_dev && tbuf.st_ino == dbuf.st_ino){
	    rename_file(filename, crashfile);
	    break;
	}
    }

    /* if current debug file name not found, write it by hand */
    if(i > ps_global->debug_nfiles){
	FILE *cfp;
	char  buf[1025];

	/*
	 * Copy the debug temp file into the 
	 */
	if(cfp = fopen(crashfile, "w")){
	    buf[1024] = '\0';
	    fseek(dfile, 0L, 0);
	    while(fgets(buf, 1025, dfile) && fputs(buf, cfp) != EOF)
	      ;

	    fclose(cfp);
	}
    }

    fclose(dfile);
}


#define CHECK_EVERY_N_TIMES 100
#define MAX_DEBUG_FILE_SIZE 200000L
/*
 * This is just to catch runaway Pines that are looping spewing out
 * debugging (and filling up a file system).  The stop doesn't have to be
 * at all precise, just soon enough to hopefully prevent filling the
 * file system.  If the debugging level is high (9 for now), then we're
 * presumably looking for some problem, so don't truncate.
 */
int
do_debug(debug_fp)
FILE *debug_fp;
{
    static int counter = CHECK_EVERY_N_TIMES;
    static int ok = 1;
    long filesize;

    if(debug == DEFAULT_DEBUG
       && !ps_global->debug_flush
       && !ps_global->debug_timestamp
       && ps_global->debug_imap < 2
       && ok
       && --counter <= 0){
	if((filesize = fp_file_size(debug_fp)) != -1L)
	  ok = (unsigned long)filesize < (unsigned long)MAX_DEBUG_FILE_SIZE;

	counter = CHECK_EVERY_N_TIMES;
	if(!ok){
	    fprintf(debug_fp, "\n\n --- No more debugging ---\n");
	    fprintf(debug_fp,
		"     (debug file growing too large - over %ld bytes)\n\n",
		MAX_DEBUG_FILE_SIZE);
	    fflush(debug_fp);
	}
    }

    if(ok && ps_global->debug_timestamp)
      fprintf(debug_fp, "\n%s\n", debug_time(0));

    return(ok);
}


/*
 * Returns a pointer to static string for a timestamp.
 *
 * If timestamp is set .subseconds are added if available.
 * If include_date is set the date is appended.
 */
char *
debug_time(include_date)
    int include_date;
{
    time_t          t;
    struct tm      *tm_now;
    struct timeval  tp;
    struct timezone tzp;
    static char     timestring[23];
    char            subsecond[8];
    char            datestr[7];

    if(gettimeofday(&tp, &tzp) == 0){
	t = (time_t)tp.tv_sec;
	if(include_date){
	    tm_now = localtime(&t);
	    sprintf(datestr, " %d/%d", tm_now->tm_mon+1, tm_now->tm_mday);
	}
	else
	  datestr[0] = '\0';

	if(ps_global->debug_timestamp)
	  sprintf(subsecond, ".%06ld", tp.tv_usec);
	else
	  subsecond[0] = '\0';

	sprintf(timestring, "%.8s%s%s", ctime(&t)+11, subsecond, datestr);
    }
    else
      timestring[0] = '\0';

    return(timestring);
}
#endif /* DEBUG */


/*
 * Fills in the passed in structure with the current time.
 *
 * Returns 0 if ok
 *        -1 if can't do it
 */
int
get_time(our_time_val)
    TIMEVAL_S *our_time_val;
{
    struct timeval  tp;
    struct timezone tzp;

    if(gettimeofday(&tp, &tzp) == 0){
	our_time_val->sec  = tp.tv_sec;
	our_time_val->usec = tp.tv_usec;
	return 0;
    }
    else
      return -1;
}


/*
 * Returns the difference between the two values, in microseconds.
 * Value returned is first - second.
 */
long
time_diff(first, second)
    TIMEVAL_S *first,
              *second;
{
    return(1000000L*(first->sec - second->sec) + (first->usec - second->usec));
}



/*======================================================================
       Things having to do with reading from the tty driver and keyboard
          - initialize tty driver and reset tty driver
          - read a character from terminal with keyboard escape seqence mapping
          - initialize keyboard (keypad or such) and reset keyboard
          - prompt user for a line of input
          - read a command from keyboard with timeouts.

 ====*/


/*
 * Helpful definitions
 */
#define	RETURN_CH(X)	return(key_recorder((X)))
/*
 * Should really be using pico's TERM's t_getchar to read a character but
 * we're just calling ttgetc directly for now. Ttgetc is the same as
 * t_getchar whenever we use it so we're avoiding the trouble of initializing
 * the TERM struct and calling ttgetc directly.
 */
#define READ_A_CHAR()	ttgetc(NO_OP_COMMAND, key_recorder, read_bail)


/*
 * Internal prototypes
 */
int  pine_simple_ttgetc PROTO((int (*)(), void (*)()));
void line_paint PROTO((int, int *));
int  process_config_input PROTO((int *));
int  check_for_timeout PROTO((int));
void read_bail PROTO((void));


/*----------------------------------------------------------------------
    Initialize the tty driver to do single char I/O and whatever else  (UNIX)

   Args:  struct pine

 Result: tty driver is put in raw mode so characters can be read one
         at a time. Returns -1 if unsuccessful, 0 if successful.

Some file descriptor voodoo to allow for pipes across vforks. See 
open_mailer for details.
  ----------------------------------------------------------------------*/
init_tty_driver(ps)
     struct pine *ps;
{
#ifdef	MOUSE
    if(F_ON(F_ENABLE_MOUSE, ps_global))
      init_mouse();
#endif	/* MOUSE */

    /* turn off talk permission by default */
    
    if(F_ON(F_ALLOW_TALK, ps))
      allow_talk(ps);
    else
      disallow_talk(ps);

    return(PineRaw(1));
}



/*----------------------------------------------------------------------
   Set or clear the specified tty mode

   Args: ps --  struct pine
	 mode -- mode bits to modify
	 clear -- whether or not to clear or set

 Result: tty driver mode change. 
  ----------------------------------------------------------------------*/
void
tty_chmod(ps, mode, func)
    struct pine *ps;
    int		 mode;
    int		 func;
{
    char	*tty_name;
    int		 new_mode;
    struct stat  sbuf;
    static int   saved_mode = -1;

    /* if no problem figuring out tty's name & mode? */
    if((((tty_name = (char *) ttyname(STDIN_FD)) != NULL
	 && fstat(STDIN_FD, &sbuf) == 0)
	|| ((tty_name = (char *) ttyname(STDOUT_FD)) != NULL
	    && fstat(STDOUT_FD, &sbuf) == 0))
       && !(func == TMD_RESET && saved_mode < 0)){
	new_mode = (func == TMD_RESET)
		     ? saved_mode
		     : (func == TMD_CLEAR)
			? (sbuf.st_mode & ~mode)
			: (sbuf.st_mode | mode);
	/* assign tty new mode */
	if(chmod(tty_name, new_mode) == 0){
	    if(func == TMD_RESET)		/* forget we knew */
	      saved_mode = -1;
	    else if(saved_mode < 0)
	      saved_mode = sbuf.st_mode;	/* remember original */
	}
    }
}



/*----------------------------------------------------------------------
       End use of the tty, put it back into it's normal mode     (UNIX)

   Args: ps --  struct pine

 Result: tty driver mode change. 
  ----------------------------------------------------------------------*/
void
end_tty_driver(ps)
     struct pine *ps;
{
    ps = ps; /* get rid of unused parameter warning */

#ifdef	MOUSE
    end_mouse();
#endif	/* MOUSE */
    fflush(stdout);
    dprint(2, (debugfile, "about to end_tty_driver\n"));

    tty_chmod(ps, 0, TMD_RESET);
    PineRaw(0);
}



/*----------------------------------------------------------------------
    Actually set up the tty driver                             (UNIX)

   Args: state -- which state to put it in. 1 means go into raw, 0 out of

  Result: returns 0 if successful and < 0 if not.
  ----*/

PineRaw(state)
int state;
{
    int result;

    result = Raw(state);
    
    if(result == 0 && state == 1){
	/*
	 * Only go into 8 bit mode if we are doing something other
	 * than plain ASCII. This will save the folks that have
	 * their parity on their serial lines wrong thr trouble of
	 * getting it right
	 */
        if(ps_global->VAR_CHAR_SET && ps_global->VAR_CHAR_SET[0] &&
	   strucmp(ps_global->VAR_CHAR_SET, "us-ascii"))
	  bit_strip_off();

#ifdef	DEBUG
	if(debug < 9)			/* only on if full debugging set */
#endif
	quit_char_off();
	ps_global->low_speed = ttisslow();
	crlf_proc(0);
	xonxoff_proc(F_ON(F_PRESERVE_START_STOP, ps_global));
    }

    return(result);
}


#ifdef RESIZING
jmp_buf winch_state;
int     winch_occured = 0;
int     ready_for_winch = 0;
#endif

/*----------------------------------------------------------------------
     This checks whether or not a character			(UNIX)
     is ready to be read, or it times out.

    Args:  time_out --  number of seconds before it will timeout

  Result: Returns a NO_OP_IDLE or a NO_OP_COMMAND if the timeout expires
	  before input is available, or a KEY_RESIZE if a resize event
	  occurs, or READY_TO_READ if input is available before the timeout.
  ----*/
int
check_for_timeout(time_out)
    int time_out;
{
    int res;

    fflush(stdout);

#ifdef RESIZING
    if(!winch_occured){
	if(setjmp(winch_state) != 0){
	    winch_occured = 1;
	    ready_for_winch = 0;

	    /*
	     * Need to unblock signal after longjmp from handler, because
	     * signal is normally unblocked upon routine exit from the handler.
	     */
	    our_sigunblock(SIGWINCH);
	}
	else
	  ready_for_winch = 1;
    }

    if(winch_occured){
	winch_occured = ready_for_winch = 0;
	fix_windsize(ps_global);
	return(KEY_RESIZE);
    }
#endif /* RESIZING */

    switch(res = input_ready(time_out)){
      case BAIL_OUT:
	read_bail();			/* non-tragic exit */
	/* NO RETURN */

      case PANIC_NOW:
	panic1("Select error: %s\n", error_description(errno));
	/* NO RETURN */

      case READ_INTR:
	res = NO_OP_COMMAND;
	/* fall through */

      case NO_OP_IDLE:
      case NO_OP_COMMAND:
      case READY_TO_READ:
#ifdef RESIZING
	ready_for_winch = 0;
#endif
	return(res);
    }
}



/*----------------------------------------------------------------------
  Read input characters with lots of processing for arrow keys and such  (UNIX)

 Args:  time_out -- The timeout to for the reads 

 Result: returns the character read. Possible special chars.

    This deals with function and arrow keys as well. 

  The idea is that this routine handles all escape codes so it done in
  only one place. Especially so the back arrow key can work when entering
  things on a line. Also so all function keys can be disabled and not
  cause weird things to happen.
  ---*/
int
read_char(time_out)
    int time_out;
{
    int ch, status, cc;

    /* Get input from initial-keystrokes */
    if(process_config_input(&ch))
      return(ch);

    /*
     * We only check for timeouts at the start of read_char, not in the
     * middle of escape sequences.
     */
    if((ch = check_for_timeout(time_out)) != READY_TO_READ)
      goto done;
    
    ps_global->time_of_last_input = time((time_t *)0);

    switch(status = kbseq(pine_simple_ttgetc, key_recorder, read_bail, &ch)){
      case KEY_DOUBLE_ESC:
	/*
	 * Special hack to get around comm devices eating control characters.
	 */
	if(check_for_timeout(5) != READY_TO_READ){
	    ch = KEY_JUNK;		/* user typed ESC ESC, then stopped */
	    goto done;
	}
	else
	  ch = READ_A_CHAR();

	ch &= 0x7f;
	if(isdigit((unsigned char)ch)){
	    int n = 0, i = ch - '0';

	    if(i < 0 || i > 2){
		ch = KEY_JUNK;
		goto done;		/* bogus literal char value */
	    }

	    while(n++ < 2){
		if(check_for_timeout(5) != READY_TO_READ
		   || (!isdigit((unsigned char) (ch = READ_A_CHAR()))
		       || (n == 1 && i == 2 && ch > '5')
		       || (n == 2 && i == 25 && ch > '5'))){
		    ch = KEY_JUNK;	/* user typed ESC ESC #, stopped */
		    goto done;
		}

		i = (i * 10) + (ch - '0');
	    }

	    ch = i;
	}
	else{
	    if(islower((unsigned char)ch))	/* canonicalize if alpha */
	      ch = toupper((unsigned char)ch);

	    ch = (isalpha((unsigned char)ch) || ch == '@'
		  || (ch >= '[' && ch <= '_'))
		   ? ctrl(ch) : ((ch == SPACE) ? ctrl('@'): ch);
	}

	goto done;

#ifdef MOUSE
      case KEY_XTERM_MOUSE:
	if(mouseexist()){
	    /*
	     * Special hack to get mouse events from an xterm.
	     * Get the details, then pass it past the keymenu event
	     * handler, and then to the installed handler if there
	     * is one...
	     */
	    static int down = 0;
	    int        x, y, button;
	    unsigned   cmd;

	    clear_cursor_pos();
	    button = READ_A_CHAR() & 0x03;

	    x = READ_A_CHAR() - '!';
	    y = READ_A_CHAR() - '!';

	    ch = NO_OP_COMMAND;
	    if(button == 0){		/* xterm button 1 down */
		down = 1;
		if(checkmouse(&cmd, 1, x, y))
		  ch = (int)cmd;
	    }
	    else if (down && button == 3){
		down = 0;
		if(checkmouse(&cmd, 0, x, y))
		  ch = (int)cmd;
	    }

	    goto done;
	}

	break;
#endif /* MOUSE */

      case  KEY_UP	:
      case  KEY_DOWN	:
      case  KEY_RIGHT	:
      case  KEY_LEFT	:
      case  KEY_PGUP	:
      case  KEY_PGDN	:
      case  KEY_HOME	:
      case  KEY_END	:
      case  KEY_DEL	:
      case  PF1		:
      case  PF2		:
      case  PF3		:
      case  PF4		:
      case  PF5		:
      case  PF6		:
      case  PF7		:
      case  PF8		:
      case  PF9		:
      case  PF10	:
      case  PF11	:
      case  PF12	:
        dprint(9, (debugfile, "Read char returning: %d %s\n",
                   status, pretty_command(status)));
	return(status);

      case KEY_SWALLOW_Z:
	status = KEY_JUNK;
      case KEY_SWAL_UP:
      case KEY_SWAL_DOWN:
      case KEY_SWAL_LEFT:
      case KEY_SWAL_RIGHT:
	do
	  if(check_for_timeout(2) != READY_TO_READ){
	      status = KEY_JUNK;
	      break;
	  }
	while(!strchr("~qz", READ_A_CHAR()));
	ch = (status == KEY_JUNK) ? status : status - (KEY_SWAL_UP - KEY_UP);
	goto done;

      case KEY_KERMIT:
	do{
	    cc = ch;
	    if(check_for_timeout(2) != READY_TO_READ){
		status = KEY_JUNK;
		break;
	    }
	    else
	      ch = READ_A_CHAR();
	}while(cc != '\033' && ch != '\\');

	ch = KEY_JUNK;
	goto done;

      case BADESC:
	ch = KEY_JUNK;
	goto done;

      case 0: 	/* regular character */
      default:
	/*
	 * we used to strip (ch &= 0x7f;), but this seems much cleaner
	 * in the face of line noise and has the benefit of making it
	 * tougher to emit mistakenly labeled MIME...
	 */
	if((ch & 0x80) && (!ps_global->VAR_CHAR_SET
			   || !strucmp(ps_global->VAR_CHAR_SET, "US-ASCII"))){
	    dprint(9, (debugfile, "Read char returning: %d %s\n",
		       status, pretty_command(status)));
	    return(KEY_JUNK);
	}
	else if(ch == ctrl('Z')){
	    dprint(9, (debugfile, "Read char calling do_suspend\n"));
	    return(do_suspend());
	}


      done:
        dprint(9, (debugfile, "Read char returning: %d %s\n",
                   ch, pretty_command(ch)));
        return(ch);
    }
}


/*----------------------------------------------------------------------
  Reading input somehow failed and we need to shutdown now

 Args:  none

 Result: pine exits

  ---*/
void
read_bail()
{
    end_signals(1);
    if(ps_global->inbox_stream){
	if(ps_global->inbox_stream == ps_global->mail_stream)
	  ps_global->mail_stream = NULL;

	if(!ps_global->inbox_stream->lock)		/* shouldn't be... */
	  pine_close_stream(ps_global->inbox_stream);
    }

    if(ps_global->mail_stream && !ps_global->mail_stream->lock)
      pine_close_stream(ps_global->mail_stream);

    end_keyboard(F_ON(F_USE_FK,ps_global));
    end_tty_driver(ps_global);
    if(filter_data_file(0))
      unlink(filter_data_file(0));

    exit(0);
}


int
pine_simple_ttgetc(fi, fv)
    int	 (*fi)();
    void (*fv)();
{
    int ch;

#ifdef RESIZING
    if(!winch_occured){
	if(setjmp(winch_state) != 0){
	    winch_occured = 1;
	    ready_for_winch = 0;

	    /*
	     * Need to unblock signal after longjmp from handler, because
	     * signal is normally unblocked upon routine exit from the handler.
	     */
	    our_sigunblock(SIGWINCH);
	}
	else
	  ready_for_winch = 1;
    }

    if(winch_occured){
	winch_occured = ready_for_winch = 0;
	fix_windsize(ps_global);
	return(KEY_RESIZE);
    }
#endif /* RESIZING */

    ch = simple_ttgetc(fi, fv);

#ifdef RESIZING
    ready_for_winch = 0;
#endif

    return(ch);
}



extern char term_name[];
/* -------------------------------------------------------------------
     Set up the keyboard -- usually enable some function keys  (UNIX)

    Args: struct pine 

So far all we do here is turn on keypad mode for certain terminals

Hack for NCSA telnet on an IBM PC to put the keypad in the right mode.
This is the same for a vtXXX terminal or [zh][12]9's which we have 
a lot of at UW
  ----*/
void
init_keyboard(use_fkeys)
     int use_fkeys;
{
    if(use_fkeys && (!strucmp(term_name,"vt102")
		     || !strucmp(term_name,"vt100")))
      printf("\033\133\071\071\150");
}



/*----------------------------------------------------------------------
     Clear keyboard, usually disable some function keys           (UNIX)

   Args:  pine state (terminal type)

 Result: keyboard state reset
  ----*/
void
end_keyboard(use_fkeys)
     int use_fkeys;
{
    if(use_fkeys && (!strcmp(term_name, "vt102")
		     || !strcmp(term_name, "vt100"))){
	printf("\033\133\071\071\154");
	fflush(stdout);
    }
}


#ifdef	_WINDOWS
#line 3 "osdep/termin.gen"

static int g_mc_row, g_mc_col;

int	pcpine_oe_cursor PROTO((int, long));
#endif


/*
 *     Generic tty input routines
 */


/*----------------------------------------------------------------------
        Read a character from keyboard with timeout
 Input:  none

 Result: Returns command read via read_char
         Times out and returns a null command every so often

  Calculates the timeout for the read, and does a few other house keeping 
things.  The duration of the timeout is set in pine.c.
  ----------------------------------------------------------------------*/
int
read_command()
{
    int ch, tm = 0;
    long dtime; 

    cancel_busy_alarm(-1);
    tm = (messages_queued(&dtime) > 1) ? (int)dtime : timeo;

    /*
     * Before we sniff at the input queue, make sure no external event's
     * changed our picture of the message sequence mapping.  If so,
     * recalculate the dang thing and run thru whatever processing loop
     * we're in again...
     */
    if(ps_global->expunge_count){
	q_status_message3(SM_ORDER, 3, 3,
			  "%s message%s expunged from folder \"%s\"",
			  long2string(ps_global->expunge_count),
			  plural(ps_global->expunge_count),
			  pretty_fn(ps_global->cur_folder));
	ps_global->expunge_count = 0L;
	display_message('x');
    }

    if(ps_global->inbox_expunge_count){
	q_status_message3(SM_ORDER, 3, 3,
			  "%s message%s expunged from folder \"%s\"",
			  long2string(ps_global->inbox_expunge_count),
			  plural(ps_global->inbox_expunge_count),
			  pretty_fn(ps_global->inbox_name));
	ps_global->inbox_expunge_count = 0L;
	display_message('x');
    }

    if(ps_global->mail_box_changed && ps_global->new_mail_count){
        dprint(2, (debugfile, "Noticed %ld new msgs! \n",
		   ps_global->new_mail_count));
	return(NO_OP_COMMAND);		/* cycle thru so caller can update */
    }

    ch = read_char(tm);
    dprint(9, (debugfile, "Read command returning: %d %s\n", ch,
              pretty_command(ch)));
    if(ch != NO_OP_COMMAND && ch != NO_OP_IDLE && ch != KEY_RESIZE)
      zero_new_mail_count();

#ifdef	BACKGROUND_POST
    /*
     * Any expired children to report on?
     */
    if(ps_global->post && ps_global->post->pid == 0){
	int   winner = 0;

	if(ps_global->post->status < 0){
	    q_status_message(SM_ORDER | SM_DING, 3, 3, "Abysmal failure!");
	}
	else{
	    (void) pine_send_status(ps_global->post->status,
				    ps_global->post->fcc, tmp_20k_buf,
				    &winner);
	    q_status_message(SM_ORDER | (winner ? 0 : SM_DING), 3, 3,
			     tmp_20k_buf);

	}

	if(!winner)
	  q_status_message(SM_ORDER, 0, 3,
	  "Re-send via \"Compose\" then \"Yes\" to \"Continue INTERRUPTED?\"");

	if(ps_global->post->fcc)
	  fs_give((void **) &ps_global->post->fcc);

	fs_give((void **) &ps_global->post);
    }
#endif

    return(ch);
}




/*
 *
 */
static struct display_line {
    int   row, col;			/* where display starts		 */
    int   dlen;				/* length of display line	 */
    char *dl;				/* line on display		 */
    char *vl;				/* virtual line 		 */
    int   vlen;				/* length of virtual line        */
    int   vused;			/* length of virtual line in use */
    int   vbase;			/* first virtual char on display */
} dline;



static struct key oe_keys[] =
       {{"^G","Help",KS_SCREENHELP},	{"^C","Cancel",KS_NONE},
	{"^T","xxx",KS_NONE},		{"Ret","Accept",KS_NONE},
	{NULL,NULL,KS_NONE},		{NULL,NULL,KS_NONE},
	{NULL,NULL,KS_NONE},		{NULL,NULL,KS_NONE},
	{NULL,NULL,KS_NONE},		{NULL,NULL,KS_NONE},
	{NULL,NULL,KS_NONE},		{NULL,NULL,KS_NONE}};
INST_KEY_MENU(oe_keymenu, oe_keys);
#define	OE_HELP_KEY	0
#define	OE_CANCEL_KEY	1
#define	OE_CTRL_T_KEY	2
#define	OE_ENTER_KEY	3


/*---------------------------------------------------------------------- 
       Prompt user for a string in status line with various options

  Args: string -- the buffer result is returned in, and original string (if 
                   any) is passed in.
        y_base -- y position on screen to start on. 0,0 is upper left
                    negative numbers start from bottom
        x_base -- column position on screen to start on. 0,0 is upper left
        field_len -- Maximum length of string to accept
        prompt -- The string to prompt with
	escape_list -- pointer to array of ESCKEY_S's.  input chars matching
                       those in list return value from list.
        help   -- Arrary of strings for help text in bottom screen lines
        flags  -- pointer (because some are return values) to flags
		  OE_USER_MODIFIED       - Set on return if user modified buffer
		  OE_DISALLOW_CANCEL     - No cancel in menu.
		  OE_DISALLOW_HELP       - No help in menu.
		  OE_KEEP_TRAILING_SPACE - Allow trailing space.
		  OE_SEQ_SENSITIVE       - Caller is sensitive to sequence
					   number changes.
		  OE_APPEND_CURRENT      - String should not be truncated
					   before accepting user input.
		  OE_PASSWD              - Don't echo on screen.

  Result:  editing input string
            returns -1 unexpected errors
            returns 0  normal entry typed (editing and return or PF2)
            returns 1  typed ^C or PF2 (cancel)
            returns 3  typed ^G or PF1 (help)
            returns 4  typed ^L for a screen redraw

  WARNING: Care is required with regard to the escape_list processing.
           The passed array is terminated with an entry that has ch = -1.
           Function key labels and key strokes need to be setup externally!
	   Traditionally, a return value of 2 is used for ^T escapes.

   Unless in escape_list, tabs are trapped by isprint().
This allows near full weemacs style editing in the line
   ^A beginning of line
   ^E End of line
   ^R Redraw line
   ^G Help
   ^F forward
   ^B backward
   ^D delete
----------------------------------------------------------------------*/

optionally_enter(string, y_base, x_base, field_len,
                 prompt, escape_list, help, flags)
     char       *string, *prompt;
     ESCKEY_S   *escape_list;
     HelpType	 help;
     int         x_base, y_base, field_len;
     int	*flags;
{
    register char *s2;
    register int   field_pos;
    int            i, j, return_v, cols, ch, prompt_len, too_thin,
                   real_y_base, km_popped, passwd;
    char          *saved_original = NULL, *k, *kb;
    char          *kill_buffer = NULL;
    char         **help_text;
    int		   fkey_table[12];
    struct	   key_menu *km;
    bitmap_t	   bitmap;
    COLOR_PAIR    *lastc = NULL, *promptc = NULL;
    struct variable *vars = ps_global->vars;
#ifdef	_WINDOWS
    int		   cursor_shown;
#endif

    dprint(5, (debugfile, "=== optionally_enter called ===\n"));
    dprint(9, (debugfile, "string:\"%s\"  y:%d  x:%d  length: %d append: %d\n",
               string, x_base, y_base, field_len,
	       (flags && *flags & OE_APPEND_CURRENT)));
    dprint(9, (debugfile, "passwd:%d   prompt:\"%s\"   label:\"%s\"\n",
               (flags && *flags & OE_PASSWD),
	       prompt, (escape_list && escape_list[0].ch != -1)
				 ? escape_list[0].label: ""));

#ifdef _WINDOWS
    if (mswin_usedialog ()) {
	MDlgButton		button_list[12];
	int			b;
	int			i;

	memset (&button_list, 0, sizeof (MDlgButton) * 12);
	b = 0;
	for (i = 0; escape_list && escape_list[i].ch != -1 && i < 11; ++i) {
	    if (escape_list[i].name != NULL
		&& escape_list[i].ch > 0 && escape_list[i].ch < 256) {
		button_list[b].ch = escape_list[i].ch;
		button_list[b].rval = escape_list[i].rval;
		button_list[b].name = escape_list[i].name;
		button_list[b].label = escape_list[i].label;
		++b;
	    }
	}
	button_list[b].ch = -1;


	help_text = get_help_text (help);
	return_v = mswin_dialog (prompt, string, field_len, 
				 (flags && *flags & OE_APPEND_CURRENT),
				 (flags && *flags & OE_PASSWD),
				 button_list,
				 help_text, flags ? *flags : OE_NONE);
	free_list_array (&help_text);
        return (return_v);
    }
#endif

    suspend_busy_alarm();
    cols       = ps_global->ttyo->screen_cols;
    prompt_len = strlen(prompt);
    too_thin   = 0;
    km_popped  = 0;
    if(y_base > 0) {
        real_y_base = y_base;
    } else {
        real_y_base=  y_base + ps_global->ttyo->screen_rows;
        if(real_y_base < 2)
          real_y_base = ps_global->ttyo->screen_rows;
    }

    flush_ordered_messages();
    mark_status_dirty();
    if(flags && *flags & OE_APPEND_CURRENT) /* save a copy in case of cancel */
      saved_original = cpystr(string);

    /*
     * build the function key mapping table, skipping predefined keys...
     */
    memset(fkey_table, NO_OP_COMMAND, 12 * sizeof(int));
    for(i = 0, j = 0; escape_list && escape_list[i].ch != -1 && i+j < 12; i++){
	if(i+j == OE_HELP_KEY)
	  j++;

	if(i+j == OE_CANCEL_KEY)
	  j++;

	if(i+j == OE_ENTER_KEY)
	  j++;

	fkey_table[i+j] = escape_list[i].ch;
    }

#if defined(HELPFILE)
    help_text = (help != NO_HELP) ? get_help_text(help) : (char **)NULL;
#else
    help_text = help;
#endif
    if(help_text){			/*---- Show help text -----*/
	int width = ps_global->ttyo->screen_cols - x_base;

	if(FOOTER_ROWS(ps_global) == 1){
	    km_popped++;
	    FOOTER_ROWS(ps_global) = 3;
	    clearfooter(ps_global);

	    y_base = -3;
	    real_y_base = y_base + ps_global->ttyo->screen_rows;
	}

	for(j = 0; j < 2 && help_text[j]; j++){
	    MoveCursor(real_y_base + 1 + j, x_base);
	    CleartoEOLN();

	    if(width < strlen(help_text[j])){
		char *tmp = fs_get((width + 1) * sizeof(char));
		strncpy(tmp, help_text[j], width);
		tmp[width] = '\0';
		PutLine0(real_y_base + 1 + j, x_base, tmp);
		fs_give((void **)&tmp);
	    }
	    else
	      PutLine0(real_y_base + 1 + j, x_base, help_text[j]);
	}

#if defined(HELPFILE)
	free_list_array(&help_text);
#endif

    } else {
	clrbitmap(bitmap);
	clrbitmap((km = &oe_keymenu)->bitmap);		/* force formatting */
	if(!(flags && (*flags) & OE_DISALLOW_HELP))
	  setbitn(OE_HELP_KEY, bitmap);

	setbitn(OE_ENTER_KEY, bitmap);
	if(!(flags && (*flags) & OE_DISALLOW_CANCEL))
	  setbitn(OE_CANCEL_KEY, bitmap);

	setbitn(OE_CTRL_T_KEY, bitmap);

        /*---- Show the usual possible keys ----*/
	for(i=0,j=0; escape_list && escape_list[i].ch != -1 && i+j < 12; i++){
	    if(i+j == OE_HELP_KEY)
	      j++;

	    if(i+j == OE_CANCEL_KEY)
	      j++;

	    if(i+j == OE_ENTER_KEY)
	      j++;

	    oe_keymenu.keys[i+j].label = escape_list[i].label;
	    oe_keymenu.keys[i+j].name = escape_list[i].name;
	    setbitn(i+j, bitmap);
	}

	for(i = i+j; i < 12; i++)
	  if(!(i == OE_HELP_KEY || i == OE_ENTER_KEY || i == OE_CANCEL_KEY))
	    oe_keymenu.keys[i].name = NULL;

	draw_keymenu(km, bitmap, cols, 1-FOOTER_ROWS(ps_global), 0, FirstMenu);
    }
    
    if(pico_usingcolor() && VAR_PROMPT_FORE_COLOR &&
       VAR_PROMPT_BACK_COLOR &&
       pico_is_good_color(VAR_PROMPT_FORE_COLOR) &&
       pico_is_good_color(VAR_PROMPT_BACK_COLOR)){
	lastc = pico_get_cur_color();
	if(lastc){
	    promptc = new_color_pair(VAR_PROMPT_FORE_COLOR,
				     VAR_PROMPT_BACK_COLOR);
	    (void)pico_set_colorp(promptc, PSC_NONE);
	}
    }
    else
      StartInverse();

    /*
     * if display length isn't wide enough to support input,
     * shorten up the prompt...
     */
    if((dline.dlen = cols - (x_base + prompt_len + 1)) < 5){
	prompt_len += (dline.dlen - 5);	/* adding negative numbers */
	prompt     -= (dline.dlen - 5);	/* subtracting negative numbers */
	dline.dlen  = 5;
    }

    dline.dl    = fs_get((size_t)dline.dlen + 1);
    memset((void *)dline.dl, 0, (size_t)(dline.dlen + 1) * sizeof(char));
    dline.row   = real_y_base;
    dline.col   = x_base + prompt_len;
    dline.vl    = string;
    dline.vlen  = --field_len;		/* -1 for terminating NULL */
    dline.vbase = field_pos = 0;

#ifdef	_WINDOWS
    cursor_shown = mswin_showcaret(1);
#endif
    
    PutLine0(real_y_base, x_base, prompt);
    /* make sure passed in string is shorter than field_len */
    /* and adjust field_pos..                               */

    while((flags && *flags & OE_APPEND_CURRENT) &&
          field_pos < field_len && string[field_pos] != '\0')
      field_pos++;

    string[field_pos] = '\0';
    dline.vused = (int)(&string[field_pos] - string);
    passwd = (flags && *flags & OE_PASSWD) ? 1 : 0;
    line_paint(field_pos, &passwd);

    /*----------------------------------------------------------------------
      The main loop
   
    here field_pos is the position in the string.
    s always points to where we are in the string.
    loops until someone sets the return_v.
      ----------------------------------------------------------------------*/
    return_v = -10;

    while(return_v == -10) {

#ifdef	MOUSE
	mouse_in_content(KEY_MOUSE, -1, -1, 0x5, 0);
	register_mfunc(mouse_in_content, 
		       real_y_base, x_base + prompt_len,
		       real_y_base, ps_global->ttyo->screen_cols);
#endif
#ifdef	_WINDOWS
	mswin_allowpaste(MSWIN_PASTE_LINE);
	g_mc_row = real_y_base;
	g_mc_col = x_base + prompt_len;
	mswin_mousetrackcallback(pcpine_oe_cursor);
#endif

	/* Timeout 10 min to keep imap mail stream alive */
        ch = read_char(600);

#ifdef	MOUSE
	clear_mfunc(mouse_in_content);
#endif
#ifdef	_WINDOWS
	mswin_allowpaste(MSWIN_PASTE_DISABLE);
	mswin_mousetrackcallback(NULL);
#endif

	/*
	 * Don't want to intercept all characters if typing in passwd.
	 * We select an ad hoc set that we will catch and let the rest
	 * through.  We would have caught the set below in the big switch
	 * but we skip the switch instead.  Still catch things like ^K,
	 * DELETE, ^C, RETURN.
	 */
	if(passwd)
	  switch(ch) {
            case ctrl('F'):  
	    case KEY_RIGHT:
            case ctrl('B'):
	    case KEY_LEFT:
            case ctrl('U'):
            case ctrl('A'):
	    case KEY_HOME:
            case ctrl('E'):
	    case KEY_END:
	    case TAB:
	      goto ok_for_passwd;
	  }

        if(too_thin && ch != KEY_RESIZE && ch != ctrl('Z') && ch != ctrl('C'))
          goto bleep;

	switch(ch) {

	    /*--------------- KEY RIGHT ---------------*/
          case ctrl('F'):  
	  case KEY_RIGHT:
	    if(field_pos >= field_len || string[field_pos] == '\0')
              goto bleep;

	    line_paint(++field_pos, &passwd);
	    break;

	    /*--------------- KEY LEFT ---------------*/
          case ctrl('B'):
	  case KEY_LEFT:
	    if(field_pos <= 0)
	      goto bleep;

	    line_paint(--field_pos, &passwd);
	    break;

          /*-------------------- WORD SKIP --------------------*/
	  case ctrl('@'):
	    /*
	     * Note: read_char *can* return NO_OP_COMMAND which is
	     * the def'd with the same value as ^@ (NULL), BUT since
	     * read_char has a big timeout (>25 secs) it won't.
	     */

	    /* skip thru current word */
	    while(string[field_pos]
		  && isalnum((unsigned char) string[field_pos]))
	      field_pos++;

	    /* skip thru current white space to next word */
	    while(string[field_pos]
		  && !isalnum((unsigned char) string[field_pos]))
	      field_pos++;

	    line_paint(field_pos, &passwd);
	    break;

          /*--------------------  RETURN --------------------*/
	  case PF4:
	    if(F_OFF(F_USE_FK,ps_global)) goto bleep;
	  case ctrl('J'): 
	  case ctrl('M'): 
	    return_v = 0;
	    break;

          /*-------------------- Destructive backspace --------------------*/
	  case '\177': /* DEL */
	  case ctrl('H'):
            /*   Try and do this with by telling the terminal to delete a
                 a character. If that fails, then repaint the rest of the
                 line, acheiving the same much less efficiently
             */
	    if(field_pos <= 0)
	      goto bleep;

	    field_pos--;
	    /* drop thru to pull line back ... */

          /*-------------------- Delete char --------------------*/
	  case ctrl('D'): 
	  case KEY_DEL: 
            if(field_pos >= field_len || !string[field_pos])
	      goto bleep;

	    dline.vused--;
	    for(s2 = &string[field_pos]; *s2 != '\0'; s2++)
	      *s2 = s2[1];

	    *s2 = '\0';			/* Copy last NULL */
	    line_paint(field_pos, &passwd);
	    if(flags)		/* record change if requested  */
	      *flags |= OE_USER_MODIFIED;

	    break;


            /*--------------- Kill line -----------------*/
          case ctrl('K'):
            if(kill_buffer != NULL)
              fs_give((void **)&kill_buffer);

	    if(field_pos != 0 || string[0]){
		if(!passwd && F_ON(F_DEL_FROM_DOT, ps_global))
		  dline.vused -= strlen(&string[i = field_pos]);
		else
		  dline.vused = i = 0;

		kill_buffer = cpystr(&string[field_pos = i]);
		string[field_pos] = '\0';
		line_paint(field_pos, &passwd);
		if(flags)		/* record change if requested  */
		  *flags |= OE_USER_MODIFIED;

	    }

            break;

            /*------------------- Undelete line --------------------*/
          case ctrl('U'):
            if(kill_buffer == NULL)
              goto bleep;

            /* Make string so it will fit */
            kb = cpystr(kill_buffer);
            dprint(2, (debugfile,
		       "Undelete: %d %d\n", strlen(string), field_len));
            if(strlen(kb) + strlen(string) > field_len) 
                kb[field_len - strlen(string)] = '\0';
            dprint(2, (debugfile,
		       "Undelete: %d %d\n", field_len - strlen(string),
		       strlen(kb)));
                       
            if(string[field_pos] == '\0') {
                /*--- adding to the end of the string ----*/
                for(k = kb; *k; k++)
		  string[field_pos++] = *k;

                string[field_pos] = '\0';
            } else {
                goto bleep;
                /* To lazy to do insert in middle of string now */
            }

	    if(*kb && flags)		/* record change if requested  */
	      *flags |= OE_USER_MODIFIED;

	    dline.vused = strlen(string);
            fs_give((void **)&kb);
	    line_paint(field_pos, &passwd);
            break;
            

	    /*-------------------- Interrupt --------------------*/
	  case ctrl('C'): /* ^C */ 
	    if(F_ON(F_USE_FK,ps_global)
	       || (flags && ((*flags) & OE_DISALLOW_CANCEL)))
	      goto bleep;

	    goto cancel;

	  case PF2:
	    if(F_OFF(F_USE_FK,ps_global)
	       || (flags && ((*flags) & OE_DISALLOW_CANCEL)))
	      goto bleep;

	  cancel:
	    return_v = 1;
	    if(saved_original)
	      strcpy(string, saved_original);

	    break;
	    

          case ctrl('A'):
	  case KEY_HOME:
            /*-------------------- Start of line -------------*/
	    line_paint(field_pos = 0, &passwd);
            break;


          case ctrl('E'):
	  case KEY_END:
            /*-------------------- End of line ---------------*/
	    line_paint(field_pos = dline.vused, &passwd);
            break;


	    /*-------------------- Help --------------------*/
	  case ctrl('G') : 
	  case PF1:
	    if(flags && ((*flags) & OE_DISALLOW_HELP))
	      goto bleep;
	    else if(FOOTER_ROWS(ps_global) == 1 && km_popped == 0){
		km_popped++;
		FOOTER_ROWS(ps_global) = 3;
		clearfooter(ps_global);
		if(lastc)
		  (void)pico_set_colorp(lastc, PSC_NONE);
		else
		  EndInverse();

		draw_keymenu(km, bitmap, cols, 1-FOOTER_ROWS(ps_global),
			     0, FirstMenu);

		if(promptc)
		  (void)pico_set_colorp(promptc, PSC_NONE);
		else
		  StartInverse();

		mark_keymenu_dirty();
		y_base = -3;
		dline.row = real_y_base = y_base + ps_global->ttyo->screen_rows;
		PutLine0(real_y_base, x_base, prompt);
		fs_resize((void **)&dline.dl, (size_t)dline.dlen + 1);
		memset((void *)dline.dl, 0, (size_t)(dline.dlen + 1));
		line_paint(field_pos, &passwd);
		break;
	    }

	    if(FOOTER_ROWS(ps_global) > 1){
		mark_keymenu_dirty();
		return_v = 3;
	    }
	    else
	      goto bleep;

	    break;

#ifdef	MOUSE
	  case KEY_MOUSE :
	    {
	      MOUSEPRESS mp;

	      mouse_get_last (NULL, &mp);

	      /* The clicked line have anything special on it? */
	      switch(mp.button){
		case M_BUTTON_LEFT :			/* position cursor */
		  mp.col -= x_base + prompt_len;	/* normalize column */
		  if(dline.vbase + mp.col <= dline.vused)
		    line_paint(field_pos = dline.vbase + mp.col, &passwd);

		  break;

		case M_BUTTON_RIGHT :
#ifdef	_WINDOWS
		  mp.col -= x_base + prompt_len;	/* normalize column */
		  if(dline.vbase + mp.col <= dline.vused)
		    line_paint(field_pos = dline.vbase + mp.col, &passwd);

		  mswin_allowpaste(MSWIN_PASTE_LINE);
		  mswin_paste_popup();
		  mswin_allowpaste(MSWIN_PASTE_DISABLE);
		  break;
#endif

		case M_BUTTON_MIDDLE :			/* NO-OP for now */
		default:				/* just ignore */
		  break;
	      }
	    }

	    break;
#endif

          case NO_OP_IDLE:
	    /* Keep mail stream alive */
	    i = new_mail(0, 2, NM_DEFER_SORT);
	    if(ps_global->expunge_count &&
	       flags && ((*flags) & OE_SEQ_SENSITIVE))
	      goto cancel;

	    if(i < 0){
	      line_paint(field_pos, &passwd);
	      break;			/* no changes, get on with life */
	    }
	    /* Else fall into redraw */

	    /*-------------------- Redraw --------------------*/
	  case ctrl('L'):
            /*---------------- re size ----------------*/
          case KEY_RESIZE:
            
	    dline.row = real_y_base = y_base > 0 ? y_base :
					 y_base + ps_global->ttyo->screen_rows;
	    if(lastc)
	      (void)pico_set_colorp(lastc, PSC_NONE);
	    else
	      EndInverse();

            ClearScreen();
            redraw_titlebar();
            if(ps_global->redrawer != (void (*)())NULL)
              (*ps_global->redrawer)();

            redraw_keymenu();
	    if(promptc)
	      (void)pico_set_colorp(promptc, PSC_NONE);
	    else
	      StartInverse();
            
            PutLine0(real_y_base, x_base, prompt);
            cols     =  ps_global->ttyo->screen_cols;
            too_thin = 0;
            if(cols < x_base + prompt_len + 4) {
		Writechar(BELL, 0);
                PutLine0(real_y_base, 0, "Screen's too thin. Ouch!");
                too_thin = 1;
            } else {
		dline.col   = x_base + prompt_len;
		dline.dlen  = cols - (x_base + prompt_len + 1);
		fs_resize((void **)&dline.dl, (size_t)dline.dlen + 1);
		memset((void *)dline.dl, 0, (size_t)(dline.dlen + 1));
		line_paint(field_pos, &passwd);
            }
            fflush(stdout);

            dprint(9, (debugfile,
                    "optionally_enter  RESIZE new_cols:%d  too_thin: %d\n",
                       cols, too_thin));
            break;

	  case PF3 :		/* input to potentially remap */
	  case PF5 :
	  case PF6 :
	  case PF7 :
	  case PF8 :
	  case PF9 :
	  case PF10 :
	  case PF11 :
	  case PF12 :
	      if(F_ON(F_USE_FK,ps_global)
		 && fkey_table[ch - PF1] != NO_OP_COMMAND)
		ch = fkey_table[ch - PF1]; /* remap function key input */
  
          default:
	    if(escape_list){		/* in the escape key list? */
		for(j=0; escape_list[j].ch != -1; j++){
		    if(escape_list[j].ch == ch){
			return_v = escape_list[j].rval;
			break;
		    }
		}

		if(return_v != -10)
		  break;
	    }

	    if(iscntrl(ch & 0x7f)){
       bleep:
		putc(BELL, stdout);
		continue;
	    }

       ok_for_passwd:
	    /*--- Insert a character -----*/
	    if(dline.vused >= field_len)
	      goto bleep;

	    /*---- extending the length of the string ---*/
	    for(s2 = &string[++dline.vused]; s2 - string > field_pos; s2--)
	      *s2 = *(s2-1);

	    string[field_pos++] = ch;
	    line_paint(field_pos, &passwd);
	    if(flags)		/* record change if requested  */
	      *flags |= OE_USER_MODIFIED;
		    
	}   /*---- End of switch on char ----*/
    }

#ifdef	_WINDOWS
    if(!cursor_shown)
      mswin_showcaret(0);
#endif

    fs_give((void **)&dline.dl);
    if(saved_original) 
      fs_give((void **)&saved_original);

    if(kill_buffer)
      fs_give((void **)&kill_buffer);

    if (!(flags && (*flags) & OE_KEEP_TRAILING_SPACE))
      removing_trailing_white_space(string);

    if(lastc){
	(void)pico_set_colorp(lastc, PSC_NONE);
	free_color_pair(&lastc);
	if(promptc)
	  free_color_pair(&promptc);
    }
    else
      EndInverse();

    MoveCursor(real_y_base, x_base); /* Move the cursor to show we're done */
    fflush(stdout);
    resume_busy_alarm(0);
    if(km_popped){
	FOOTER_ROWS(ps_global) = 1;
	clearfooter(ps_global);
	ps_global->mangled_body = 1;
    }

    return(return_v);
}


/*
 * line_paint - where the real work of managing what is displayed gets done.
 *              The passwd variable is overloaded: if non-zero, don't
 *              output anything, else only blat blank chars across line
 *              once and use this var to tell us we've already written the 
 *              line.
 */
void
line_paint(offset, passwd)
    int   offset;			/* current dot offset into line */
    int  *passwd;			/* flag to hide display of chars */
{
    register char *pfp, *pbp;
    register char *vfp, *vbp;
    int            extra = 0;
#define DLEN	(dline.vbase + dline.dlen)

    /*
     * for now just leave line blank, but maybe do '*' for each char later
     */
    if(*passwd){
	if(*passwd > 1)
	  return;
	else
	  *passwd = 2;		/* only blat once */

	extra = 0;
	MoveCursor(dline.row, dline.col);
	while(extra++ < dline.dlen)
	  Writechar(' ', 0);

	MoveCursor(dline.row, dline.col);
	return;
    }

    /* adjust right margin */
    while(offset >= DLEN + ((dline.vused > DLEN) ? -1 : 1))
      dline.vbase += dline.dlen/2;

    /* adjust left margin */
    while(offset < dline.vbase + ((dline.vbase) ? 2 : 0))
      dline.vbase = max(dline.vbase - (dline.dlen/2), 0);

    if(dline.vbase){				/* off screen cue left */
	vfp = &dline.vl[dline.vbase+1];
	pfp = &dline.dl[1];
	if(dline.dl[0] != '<'){
	    MoveCursor(dline.row, dline.col);
	    Writechar(dline.dl[0] = '<', 0);
	}
    }
    else{
	vfp = dline.vl;
	pfp = dline.dl;
	if(dline.dl[0] == '<'){
	    MoveCursor(dline.row, dline.col);
	    Writechar(dline.dl[0] = ' ', 0);
	}
    }

    if(dline.vused > DLEN){			/* off screen right... */
	vbp = vfp + (long)(dline.dlen-(dline.vbase ? 2 : 1));
	pbp = pfp + (long)(dline.dlen-(dline.vbase ? 2 : 1));
	if(pbp[1] != '>'){
	    MoveCursor(dline.row, dline.col+dline.dlen);
	    Writechar(pbp[1] = '>', 0);
	}
    }
    else{
	extra = dline.dlen - (dline.vused - dline.vbase);
	vbp = &dline.vl[max(0, dline.vused-1)];
	pbp = &dline.dl[dline.dlen];
	if(pbp[0] == '>'){
	    MoveCursor(dline.row, dline.col+dline.dlen);
	    Writechar(pbp[0] = ' ', 0);
	}
    }

    while(*pfp == *vfp && vfp < vbp)			/* skip like chars */
      pfp++, vfp++;

    if(pfp == pbp && *pfp == *vfp){			/* nothing to paint! */
	MoveCursor(dline.row, dline.col + (offset - dline.vbase));
	return;
    }

    /* move backward thru like characters */
    if(extra){
	while(extra >= 0 && *pbp == ' ') 		/* back over spaces */
	  extra--, pbp--;

	while(extra >= 0)				/* paint new ones    */
	  pbp[-(extra--)] = ' ';
    }

    if((vbp - vfp) == (pbp - pfp)){			/* space there? */
	while((*pbp == *vbp) && pbp != pfp)		/* skip like chars */
	  pbp--, vbp--;
    }

    if(pfp != pbp || *pfp != *vfp){			/* anything to paint?*/
	MoveCursor(dline.row, dline.col + (int)(pfp - dline.dl));

	do
	  Writechar((unsigned char)((vfp <= vbp && *vfp)
		      ? ((*pfp = *vfp++) == TAB) ? ' ' : *pfp
		      : (*pfp = ' ')), 0);
	while(++pfp <= pbp);
    }

    MoveCursor(dline.row, dline.col + (offset - dline.vbase));
}



/*----------------------------------------------------------------------
    Check to see if the given command is reasonably valid
  
  Args:  ch -- the character to check

 Result:  A valid command is returned, or a well know bad command is returned.
 
 ---*/
validatekeys(ch)
     int  ch;
{
#ifndef _WINDOWS
    if(F_ON(F_USE_FK,ps_global)) {
	if(ch >= 'a' && ch <= 'z')
	  return(KEY_JUNK);
    } else {
	if(ch >= PF1 && ch <= PF12)
	  return(KEY_JUNK);
    }
#else
    /*
     * In windows menu items are bound to a single key command which
     * gets inserted into the input stream as if the user had typed
     * that key.  But all the menues are bonund to alphakey commands,
     * not PFkeys.  to distinguish between a keyboard command and a
     * menu command we insert a flag (KEY_MENU_FLAG) into the
     * command value when setting up the bindings in
     * configure_menu_items().  Here we strip that flag.
     */
    if(F_ON(F_USE_FK,ps_global)) {
	if(ch >= 'a' && ch <= 'z' && !(ch & KEY_MENU_FLAG))
	  return(KEY_JUNK);
	ch &= ~ KEY_MENU_FLAG;
    } else {
	ch &= ~ KEY_MENU_FLAG;
	if(ch >= PF1 && ch <= PF12)
	  return(KEY_JUNK);
    }
#endif

    return(ch);
}



/*----------------------------------------------------------------------
  Prepend config'd commands to keyboard input
  
  Args:  ch -- pointer to storage for returned command

 Returns: TRUE if we're passing back a useful command, FALSE otherwise
 
 ---*/
int
process_config_input(ch)
    int *ch;
{
    static char firsttime = (char) 1;

    /* commands in config file */
    if(ps_global->initial_cmds && *ps_global->initial_cmds) {
	/*
	 * There are a few commands that may require keyboard input before
	 * we enter the main command loop.  That input should be interactive,
	 * not from our list of initial keystrokes.
	 */
	if(ps_global->dont_use_init_cmds)
	  return(0);

	*ch = *ps_global->initial_cmds++;
	if(!*ps_global->initial_cmds && ps_global->free_initial_cmds){
	    fs_give((void **)&(ps_global->free_initial_cmds));
	    ps_global->initial_cmds = 0;
	}

	return(1);
    }

    if(firsttime) {
	firsttime = 0;
	if(ps_global->in_init_seq) {
	    ps_global->in_init_seq = 0;
	    ps_global->save_in_init_seq = 0;
	    clear_cursor_pos();
	    F_SET(F_USE_FK,ps_global,ps_global->orig_use_fkeys);
	    /* draw screen */
	    *ch = ctrl('L');
	    return(1);
	}
    }

    return(0);
}


#define	TAPELEN	256
static int   tape[TAPELEN];
static long  recorded = 0L;
static short length  = 0;


/*
 * record user keystrokes
 *
 * Args:  ch -- the character to record
 *
 * Returns: character recorded
 */
int
key_recorder(ch)
    int ch;
{
    tape[recorded++ % TAPELEN] = ch;
    if(length < TAPELEN)
      length++;

    return(ch);
}


/*
 * playback user keystrokes
 *
 * Args:  ch -- ignored
 *
 * Returns: character played back or -1 to indicate end of tape
 */
int
key_playback(ch)
    int ch;
{
    ch = length ? tape[(recorded + TAPELEN - length--) % TAPELEN] : -1;
    return(ch);
}


#ifdef	_WINDOWS
int
pcpine_oe_cursor(col, row)
    int  col;
    long row;
{
    return((row == g_mc_row
	    && col >= g_mc_col
	    && col < ps_global->ttyo->screen_cols)
	    ? MSWIN_CURSOR_IBEAM
	    : MSWIN_CURSOR_ARROW);
}
#endif

/*======================================================================
       Routines for painting the screen
          - figure out what the terminal type is
          - deal with screen size changes
          - save special output sequences
          - the usual screen clearing, cursor addressing and scrolling


     This library gives programs the ability to easily access the
     termcap information and write screen oriented and raw input
     programs.  The routines can be called as needed, except that
     to use the cursor / screen routines there must be a call to
     InitScreen() first.  The 'Raw' input routine can be used
     independently, however. (Elm comment)

     Not sure what the original source of this code was. It got to be
     here as part of ELM. It has been changed significantly from the
     ELM version to be more robust in the face of inconsistent terminal
     autowrap behaviour. Also, the unused functions were removed, it was
     made to pay attention to the window size, and some code was made nicer
     (in my opinion anyways). It also outputs the terminal initialization
     strings and provides for minimal scrolling and detects terminals
     with out enough capabilities. (Pine comment, 1990)


This code used to pay attention to the "am" auto margin and "xn"
new line glitch fields, but they were so often incorrect because many
terminals can be configured to do either that we've taken it out. It
now assumes it dosn't know where the cursor is after outputing in the
80th column.
*/

#define	PUTLINE_BUFLEN	256

static int   _lines, _columns;
static int   _line  = FARAWAY;
static int   _col   = FARAWAY;
static int   _in_inverse;


/*
 * Internal prototypes
 */
static void moveabsolute PROTO((int, int));
static void CursorUp PROTO((int));
static void CursorDown PROTO((int));
static void CursorLeft PROTO((int));
static void CursorRight PROTO((int));


extern char *_clearscreen, *_moveto, *_up, *_down, *_right, *_left,
            *_setinverse, *_clearinverse,
            *_cleartoeoln, *_cleartoeos,
            *_startinsert, *_endinsert, *_insertchar, *_deletechar,
            *_deleteline, *_insertline,
            *_scrollregion, *_scrollup, *_scrolldown,
            *_termcap_init, *_termcap_end;
extern char term_name[];
extern int  _tlines, _tcolumns, _bce;

static enum  {NoScroll,UseScrollRegion,InsertDelete} _scrollmode;

char  *tgoto();				/* and the goto stuff    */



/*----------------------------------------------------------------------
      Initialize the screen for output, set terminal type, etc

   Args: tt -- Pointer to variable to store the tty output structure.

 Result:  terminal size is discovered and set in pine state
          termcap entry is fetched and stored
          make sure terminal has adequate capabilites
          evaluate scrolling situation
          returns status of indicating the state of the screen/termcap entry

      Returns:
        -1 indicating no terminal name associated with this shell,
        -2..-n  No termcap for this terminal type known
	-3 Can't open termcap file 
        -4 Terminal not powerful enough - missing clear to eoln or screen
	                                       or cursor motion
  ----*/
int
config_screen(tt)
     struct ttyo **tt;
{
    struct ttyo *ttyo;
    int          err;

    ttyo = (struct ttyo *)fs_get(sizeof (struct ttyo));

    _line  =  0;		/* where are we right now?? */
    _col   =  0;		/* assume zero, zero...     */

    /*
     * This is an ugly hack to let vtterminalinfo know it's being called
     * from pine.
     */
    Pmaster = (PICO *)1;
    if(err = vtterminalinfo(F_ON(F_TCAP_WINS, ps_global)))
      return(err);

    Pmaster = NULL;

    if(_tlines <= 0)
      _lines = DEFAULT_LINES_ON_TERMINAL;
    else
      _lines = _tlines;

    if(_tcolumns <= 0)
      _columns = DEFAULT_COLUMNS_ON_TERMINAL;
    else
      _columns = _tcolumns;

    get_windsize(ttyo);

    ttyo->header_rows = 2;
    ttyo->footer_rows = 3;

    /*---- Make sure this terminal has the capability.
        All we need is cursor address, clear line, and 
        reverse video.
      ---*/
    if(_moveto == NULL || _cleartoeoln == NULL ||
       _setinverse == NULL || _clearinverse == NULL) {
          return(-4);
    }

    dprint(1, (debugfile, "Terminal type: %s\n", term_name));

    /*------ Figure out scrolling mode -----*/
    if(_scrollregion != NULL && _scrollregion[0] != '\0' &&
    	  _scrollup != NULL && _scrollup[0] != '\0'){
        _scrollmode = UseScrollRegion;
    } else if(_insertline != NULL && _insertline[0] != '\0' &&
       _deleteline != NULL && _deleteline[0] != '\0') {
        _scrollmode = InsertDelete;
    } else {
        _scrollmode = NoScroll;
    }
    dprint(7, (debugfile, "Scroll mode: %s\n",
               _scrollmode==NoScroll ? "No Scroll" :
               _scrollmode==InsertDelete ? "InsertDelete" : "Scroll Regions"));

    if (!_left) {
    	_left = "\b";
    }

    *tt = ttyo;

    return(0);
}



/*----------------------------------------------------------------------
   Initialize the screen with the termcap string 
  ----*/
void
init_screen()
{
    if(_termcap_init)			/* init using termcap's rule */
      tputs(_termcap_init, 1, outchar);

    /* and make sure there are no scrolling surprises! */
    BeginScroll(0, ps_global->ttyo->screen_rows - 1);

    pico_toggle_color(0);
    switch(ps_global->color_style){
      case COL_NONE:
      case COL_TERMDEF:
	pico_set_color_options(0);
	break;
      case COL_ANSI8:
	pico_set_color_options(COLOR_ANSI8_OPT);
	break;
      case COL_ANSI16:
	pico_set_color_options(COLOR_ANSI16_OPT);
	break;
    }

    if(ps_global->color_style != COL_NONE)
      pico_toggle_color(1);

    /* set colors */
    if(pico_usingcolor()){
	if(ps_global->VAR_NORM_FORE_COLOR)
	  pico_nfcolor(ps_global->VAR_NORM_FORE_COLOR);

	if(ps_global->VAR_NORM_BACK_COLOR)
	  pico_nbcolor(ps_global->VAR_NORM_BACK_COLOR);

	if(ps_global->VAR_REV_FORE_COLOR)
	  pico_rfcolor(ps_global->VAR_REV_FORE_COLOR);

	if(ps_global->VAR_REV_BACK_COLOR)
	  pico_rbcolor(ps_global->VAR_REV_BACK_COLOR);

	pico_set_normal_color();
    }

    /* and make sure icon text starts out consistent */
    icon_text(NULL);
    fflush(stdout);
}
        



/*----------------------------------------------------------------------
       Get the current window size
  
   Args: ttyo -- pointer to structure to store window size in

  NOTE: we don't override the given values unless we know better
 ----*/
int
get_windsize(ttyo)
struct ttyo *ttyo;     
{
#ifdef RESIZING 
    struct winsize win;

    /*
     * Get the window size from the tty driver.  If we can't fish it from
     * stdout (pine's output is directed someplace else), try stdin (which
     * *must* be associated with the terminal; see init_tty_driver)...
     */
    if(ioctl(1, TIOCGWINSZ, &win) >= 0			/* 1 is stdout */
	|| ioctl(0, TIOCGWINSZ, &win) >= 0){		/* 0 is stdin */
	if(win.ws_row)
	  _lines = min(win.ws_row, MAX_SCREEN_ROWS);

	if(win.ws_col)
	  _columns  = min(win.ws_col, MAX_SCREEN_COLS);

        dprint(2, (debugfile, "new win size -----<%d %d>------\n",
                   _lines, _columns));
    }
    else
      /* Depending on the OS, the ioctl() may have failed because
	 of a 0 rows, 0 columns setting.  That happens on DYNIX/ptx 1.3
	 (with a kernel patch that happens to involve the negotiation
	 of window size in the telnet streams module.)  In this case
	 the error is EINVARG.  Leave the default settings. */
      dprint(1, (debugfile, "ioctl(TIOCWINSZ) failed :%s\n",
		 error_description(errno)));
#endif

    ttyo->screen_cols = min(_columns, MAX_SCREEN_COLS);
    ttyo->screen_rows = min(_lines, MAX_SCREEN_ROWS);
    return(0);
}


/*----------------------------------------------------------------------
      End use of the screen.
      Print status message, if any.
      Flush status messages.
  ----*/
void
end_screen(message)
    char *message;
{
    int footer_rows_was_one = 0;

    dprint(9, (debugfile, "end_screen called\n"));

    if(FOOTER_ROWS(ps_global) == 1){
	footer_rows_was_one++;
	FOOTER_ROWS(ps_global) = 3;
	mark_status_unknown();
    }

    flush_status_messages(1);
    blank_keymenu(_lines - 2, 0);
    MoveCursor(_lines - 2, 0);

    /* unset colors */
    if(pico_hascolor())
      pico_endcolor();

    if(_termcap_end != NULL)
      tputs(_termcap_end, 1, outchar);

    if(message){
	printf("%s\r\n", message);
    }

    if(F_ON(F_ENABLE_XTERM_NEWMAIL, ps_global) && getenv("DISPLAY"))
      icon_text("xterm");

    fflush(stdout);

    if(footer_rows_was_one){
	FOOTER_ROWS(ps_global) = 1;
	mark_status_unknown();
    }
}
    


/*----------------------------------------------------------------------
     Clear the terminal screen

 Result: The screen is cleared
         internal cursor position set to 0,0
  ----*/
void
ClearScreen()
{
    _line = 0;	/* clear leaves us at top... */
    _col  = 0;

    if(ps_global->in_init_seq)
      return;

    mark_status_unknown();
    mark_keymenu_dirty();
    mark_titlebar_dirty();

    /*
     * If the terminal doesn't have back color erase, then we have to
     * erase manually to preserve the background color.
     */
    if(pico_usingcolor() && (!_bce || !_clearscreen)){
	ClearLines(0, _lines-1);
        MoveCursor(0, 0);
    }
    else if(_clearscreen){
	tputs(_clearscreen, 1, outchar);
        moveabsolute(0, 0);	/* some clearscreens don't move correctly */
    }
}


/*----------------------------------------------------------------------
            Internal move cursor to absolute position

  Args: col -- column to move cursor to
        row -- row to move cursor to

 Result: cursor is moved (variables, not updates)
  ----*/

static void
moveabsolute(col, row)
{

	char *stuff, *tgoto();

	stuff = tgoto(_moveto, col, row);
	tputs(stuff, 1, outchar);
}


/*----------------------------------------------------------------------
        Move the cursor to the row and column number
  Args:  row number
         column number

 Result: Cursor moves
         internal position updated
  ----*/
void
MoveCursor(row, col)
     int row, col;
{
    /** move cursor to the specified row column on the screen.
        0,0 is the top left! **/

    int scrollafter = 0;

    /* we don't want to change "rows" or we'll mangle scrolling... */

    if(ps_global->in_init_seq)
      return;

    if (col < 0)
      col = 0;
    if (col >= ps_global->ttyo->screen_cols)
      col = ps_global->ttyo->screen_cols - 1;
    if (row < 0)
      row = 0;
    if (row > ps_global->ttyo->screen_rows) {
      if (col == 0)
        scrollafter = row - ps_global->ttyo->screen_rows;
      row = ps_global->ttyo->screen_rows;
    }

    if (!_moveto)
    	return;

    if (row == _line) {
      if (col == _col)
        return;				/* already there! */

      else if (abs(col - _col) < 5) {	/* within 5 spaces... */
        if (col > _col && _right)
          CursorRight(col - _col);
        else if (col < _col &&  _left)
          CursorLeft(_col - col);
        else
          moveabsolute(col, row);
      }
      else 		/* move along to the new x,y loc */
        moveabsolute(col, row);
    }
    else if (col == _col && abs(row - _line) < 5) {
      if (row < _line && _up)
        CursorUp(_line - row);
      else if (_line > row && _down)
        CursorDown(row - _line);
      else
        moveabsolute(col, row);
    }
    else if (_line == row-1 && col == 0) {
      putchar('\n');	/* that's */
      putchar('\r');	/*  easy! */
    }
    else 
      moveabsolute(col, row);

    _line = row;	/* to ensure we're really there... */
    _col  = col;

    if (scrollafter) {
      while (scrollafter--) {
        putchar('\n');
        putchar('\r');

      }
    }

    return;
}



/*----------------------------------------------------------------------
         Newline, move the cursor to the start of next line

 Result: Cursor moves
  ----*/
void
NewLine()
{
   /** move the cursor to the beginning of the next line **/

    Writechar('\n', 0);
    Writechar('\r', 0);
}



/*----------------------------------------------------------------------
        Move cursor up n lines with terminal escape sequence
 
   Args:  n -- number of lines to go up

 Result: cursor moves, 
         internal position updated

 Only for ttyout use; not outside callers
  ----*/
static void
CursorUp(n)
int n;
{
	/** move the cursor up 'n' lines **/
	/** Calling function must check that _up is not null before calling **/

    _line = (_line-n > 0? _line - n: 0);	/* up 'n' lines... */

    while (n-- > 0)
      tputs(_up, 1, outchar);
}



/*----------------------------------------------------------------------
        Move cursor down n lines with terminal escape sequence
 
    Arg: n -- number of lines to go down

 Result: cursor moves, 
         internal position updated

 Only for ttyout use; not outside callers
  ----*/
static void
CursorDown(n)
     int          n;
{
    /** move the cursor down 'n' lines **/
    /** Caller must check that _down is not null before calling **/

    _line = (_line+n < ps_global->ttyo->screen_rows ? _line + n
             : ps_global->ttyo->screen_rows);
                                               /* down 'n' lines... */

    while (n-- > 0)
    	tputs(_down, 1, outchar);
}



/*----------------------------------------------------------------------
        Move cursor left n lines with terminal escape sequence
 
   Args:  n -- number of lines to go left

 Result: cursor moves, 
         internal position updated

 Only for ttyout use; not outside callers
  ----*/
static void 
CursorLeft(n)
int n;
{
    /** move the cursor 'n' characters to the left **/
    /** Caller must check that _left is not null before calling **/

    _col = (_col - n> 0? _col - n: 0);	/* left 'n' chars... */

    while (n-- > 0)
      tputs(_left, 1, outchar);
}


/*----------------------------------------------------------------------
        Move cursor right n lines with terminal escape sequence
 
   Args:  number of lines to go right

 Result: cursor moves, 
         internal position updated

 Only for ttyout use; not outside callers
  ----*/
static void 
CursorRight(n)
int n;
{
    /** move the cursor 'n' characters to the right (nondestructive) **/
    /** Caller must check that _right is not null before calling **/

    _col = (_col+n < ps_global->ttyo->screen_cols? _col + n :
             ps_global->ttyo->screen_cols);	/* right 'n' chars... */

    while (n-- > 0)
      tputs(_right, 1, outchar);

}



/*----------------------------------------------------------------------
       Insert character on screen pushing others right

   Args: c --  character to insert

 Result: charcter is inserted if possible
         return -1 if it can't be done
  ----------------------------------------------------------------------*/
InsertChar(c)
     int c;
{
    if(_insertchar != NULL && *_insertchar != '\0') {
	tputs(_insertchar, 1, outchar);
	Writechar(c, 0);
    } else if(_startinsert != NULL && *_startinsert != '\0') {
	tputs(_startinsert, 1, outchar);
	Writechar(c, 0);
	tputs(_endinsert, 1, outchar);
    } else {
	return(-1);
    }
    return(0);
}



/*----------------------------------------------------------------------
         Delete n characters from line, sliding rest of line left

   Args: n -- number of characters to delete


 Result: characters deleted on screen
         returns -1 if it wasn't done
  ----------------------------------------------------------------------*/
DeleteChar(n)
     int n;
{
    if(_deletechar == NULL || *_deletechar == '\0')
      return(-1);

    while(n) {
	tputs(_deletechar, 1, outchar);
	n--;
    }
    return(0);
}



/*----------------------------------------------------------------------
  Go into scrolling mode, that is set scrolling region if applicable

   Args: top    -- top line of region to scroll
         bottom -- bottom line of region to scroll
	 (These are zero-origin numbers)

 Result: either set scrolling region or
         save values for later scrolling
         returns -1 if we can't scroll

 Unfortunately this seems to leave the cursor in an unpredictable place
 at least the manuals don't say where, so we force it here.
-----*/
static int __t, __b;

BeginScroll(top, bottom)
     int top, bottom;
{
    char *stuff;

    if(_scrollmode == NoScroll)
      return(-1);

    __t = top;
    __b = bottom;
    if(_scrollmode == UseScrollRegion){
        stuff = tgoto(_scrollregion, bottom, top);
        tputs(stuff, 1, outchar);
        /*-- a location  very far away to force a cursor address --*/
        _line = FARAWAY;
        _col  = FARAWAY;
    }
    return(0);
}



/*----------------------------------------------------------------------
   End scrolling -- clear scrolling regions if necessary

 Result: Clear scrolling region on terminal
  -----*/
void
EndScroll()
{
    if(_scrollmode == UseScrollRegion && _scrollregion != NULL){
	/* Use tgoto even though we're not cursor addressing because
           the format of the capability is the same.
         */
        char *stuff = tgoto(_scrollregion, ps_global->ttyo->screen_rows -1, 0);
	tputs(stuff, 1, outchar);
        /*-- a location  very far away to force a cursor address --*/
        _line = FARAWAY;
        _col  = FARAWAY;
    }
}


/* ----------------------------------------------------------------------
    Scroll the screen using insert/delete or scrolling regions

   Args:  lines -- number of lines to scroll, positive forward

 Result: Screen scrolls
         returns 0 if scroll succesful, -1 if not

 positive lines goes foward (new lines come in at bottom
 Leaves cursor at the place to insert put new text

 0,0 is the upper left
 -----*/
ScrollRegion(lines)
    int lines;
{
    int l;

    if(lines == 0)
      return(0);

    if(_scrollmode == UseScrollRegion) {
	if(lines > 0) {
	    MoveCursor(__b, 0);
	    for(l = lines ; l > 0 ; l--)
	      tputs((_scrolldown == NULL || _scrolldown[0] =='\0') ? "\n" :
		    _scrolldown, 1, outchar);
	} else {
	    MoveCursor(__t, 0);
	    for(l = -lines; l > 0; l--)
	      tputs(_scrollup, 1, outchar);
	}
    } else if(_scrollmode == InsertDelete) {
	if(lines > 0) {
	    MoveCursor(__t, 0);
	    for(l = lines; l > 0; l--) 
	      tputs(_deleteline, 1, outchar);
	    MoveCursor(__b, 0);
	    for(l = lines; l > 0; l--) 
	      tputs(_insertline, 1, outchar);
	} else {
	    for(l = -lines; l > 0; l--) {
	        MoveCursor(__b, 0);
	        tputs(_deleteline, 1, outchar);
		MoveCursor(__t, 0);
		tputs(_insertline, 1, outchar);
	    }
	}
    } else {
	return(-1);
    }
    fflush(stdout);
    return(0);
}



/*----------------------------------------------------------------------
    Write a character to the screen, keeping track of cursor position

   Args: ch -- character to output

 Result: character output
         cursor position variables updated
  ----*/
void
Writechar(ch, new_esc_len)
     register unsigned int ch;
     int      new_esc_len;
{
    static   int esc_len = 0;

    if(ps_global->in_init_seq				/* silent */
       || (F_ON(F_BLANK_KEYMENU, ps_global)		/* or bottom, */
	   && !esc_len					/* right cell */
	   && _line + 1 == ps_global->ttyo->screen_rows
	   && _col + 1 == ps_global->ttyo->screen_cols))
      return;

    if(!iscntrl(ch & 0x7f)){
	putchar(ch);
	if(esc_len > 0)
	  esc_len--;
	else
	  _col++;
    }
    else{
	switch(ch){
	  case LINE_FEED:
	    /*-- Don't have to watch out for auto wrap or newline glitch
	      because we never let it happen. See below
	      ---*/
	    putchar('\n');
	    _line = min(_line+1,ps_global->ttyo->screen_rows);
	    esc_len = 0;
	    break;

	  case RETURN :		/* move to column 0 */
	    putchar('\r');
	    _col = 0;
	    esc_len = 0;
	    break;

	  case BACKSPACE :	/* move back a space if not in column 0 */
	    if(_col != 0) {
		putchar('\b');
		_col--;
	    }			/* else BACKSPACE does nothing */

	    break;

	  case BELL :		/* ring the bell but don't advance _col */
	    putchar(ch);
	    break;

	  case TAB :		/* if a tab, output it */
	    do			/* BUG? ignores tty driver's spacing */
	      putchar(' ');
	    while(_col < ps_global->ttyo->screen_cols - 1
		  && ((++_col)&0x07) != 0);
	    break;

	  case ESCAPE :
	    /* If we're outputting an escape here, it may be part of an iso2022
	       escape sequence in which case take up no space on the screen.
	       Unfortunately such sequences are variable in length.
	       */
	    esc_len = new_esc_len - 1;
	    putchar(ch);
	    break;

	  default :		/* Change remaining control characters to ? */
	    if(F_ON(F_PASS_CONTROL_CHARS, ps_global))
	      putchar(ch);
	    else
	      putchar('?');

	    if(esc_len > 0)
	      esc_len--;
	    else
	      _col++;

	    break;
	}
    }


    /* Here we are at the end of the line. We've decided to make no
       assumptions about how the terminal behaves at this point.
       What can happen now are the following
           1. Cursor is at start of next line, and next character will
              apear there. (autowrap, !newline glitch)
           2. Cursor is at start of next line, and if a newline is output
              it'll be ignored. (autowrap, newline glitch)
           3. Cursor is still at end of line and next char will apear
              there over the top of what is there now (no autowrap).
       We ignore all this and force the cursor to the next line, just 
       like case 1. A little expensive but worth it to avoid problems
       with terminals configured so they don't match termcap
       */
    if(_col == ps_global->ttyo->screen_cols) {
        _col = 0;
        if(_line + 1 < ps_global->ttyo->screen_rows)
	  _line++;

	moveabsolute(_col, _line);
    }
}



/*----------------------------------------------------------------------
       Write string to screen at current cursor position

   Args: string -- string to be output

 Result: String written to the screen
  ----*/
void
Write_to_screen(string)				/* UNIX */
      register char *string; 
{
    while(*string)
      Writechar((unsigned char) *string++, 0);
}


/*----------------------------------------------------------------------
       Write no more than n chars of string to screen at current cursor position

   Args: string -- string to be output
	      n -- number of chars to output

 Result: String written to the screen
  ----*/
void
Write_to_screen_n(string, n)				/* UNIX */
      register char *string; 
      int            n;
{
    while(n-- && *string)
      Writechar((unsigned char) *string++, 0);
}



/*----------------------------------------------------------------------
    Clear screen to end of line on current line

 Result: Line is cleared
  ----*/
void
CleartoEOLN()
{
    int   c, starting_col, starting_line;
    char *last_bg_color;

    /*
     * If the terminal doesn't have back color erase, then we have to
     * erase manually to preserve the background color.
     */
    if(pico_usingcolor() && (!_bce || !_cleartoeoln)){
	starting_col  = _col;
	starting_line = _line;
	last_bg_color = pico_get_last_bg_color();
	pico_set_nbg_color();
	for(c = _col; c < _columns; c++)
	  Writechar(' ', 0);
	
        MoveCursor(starting_line, starting_col);
	if(last_bg_color){
	    (void)pico_set_bg_color(last_bg_color);
	    fs_give((void **)&last_bg_color);
	}
    }
    else if(_cleartoeoln)
      tputs(_cleartoeoln, 1, outchar);
}



/*----------------------------------------------------------------------
     Clear screen to end of screen from current point

 Result: screen is cleared
  ----*/
CleartoEOS()
{
    int starting_col, starting_line;

    /*
     * If the terminal doesn't have back color erase, then we have to
     * erase manually to preserve the background color.
     */
    if(pico_usingcolor() && (!_bce || !_cleartoeos)){
	starting_col  = _col;
	starting_line = _line;
        CleartoEOLN();
	ClearLines(_line+1, _lines-1);
        MoveCursor(starting_line, starting_col);
    }
    else if(_cleartoeos)
      tputs(_cleartoeos, 1, outchar);
}



/*----------------------------------------------------------------------
     function to output character used by termcap

   Args: c -- character to output

 Result: character output to screen via stdio
  ----*/
void
outchar(c)
int c;
{
	/** output the given character.  From tputs... **/
	/** Note: this CANNOT be a macro!              **/

	putc((unsigned char)c, stdout);
}



/*----------------------------------------------------------------------
     function to output string such that it becomes icon text

   Args: s -- string to write

 Result: string indicated become our "icon" text
  ----*/
void
icon_text(s)
    char *s;
{
    static char *old_s;
    static enum {ukn, yes, no} xterm;

    if(xterm == ukn)
      xterm = (getenv("DISPLAY") != NULL) ? yes : no;

    if(F_ON(F_ENABLE_XTERM_NEWMAIL,ps_global) && xterm == yes && (s || old_s)){
	fputs("\033]1;", stdout);
	fputs((old_s = s) ? s : ps_global->pine_name, stdout);
	fputs("\007", stdout);
	fflush(stdout);
    }
}


#ifdef	_WINDOWS
#line 3 "osdep/termout.gen"
#endif

/*
 * Generic tty output routines...
 */

/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 0 args

  Args:  x -- column position on the screen
         y -- row position on the screen
         line -- line of text to output

 Result: text is output
         cursor position is update
  ----*/
void
PutLine0(x, y, line)
    int            x,y;
    register char *line;
{
    MoveCursor(x,y);
    Write_to_screen(line);
}



/*----------------------------------------------------------------------
  Output line of length len to the display observing embedded attributes

 Args:  x      -- column position on the screen
        y      -- column position on the screen
        line   -- text to be output
        length -- length of text to be output

 Result: text is output
         cursor position is updated
  ----------------------------------------------------------------------*/
void
PutLine0n8b(x, y, line, length, handles)
    int            x, y, length;
    register char *line;
    HANDLE_S	  *handles;
{
    unsigned char c;
#ifdef	_WINDOWS
    int hkey = 0;
#endif

    MoveCursor(x,y);
    while(length-- && (c = (unsigned char)*line++)){

	if(c == (unsigned char)TAG_EMBED && length){
	    length--;
	    switch(*line++){
	      case TAG_INVON :
		StartInverse();
		break;
	      case TAG_INVOFF :
		EndInverse();
		break;
	      case TAG_BOLDON :
		StartBold();
		break;
	      case TAG_BOLDOFF :
		EndBold();
		break;
	      case TAG_ULINEON :
		StartUnderline();
		break;
	      case TAG_ULINEOFF :
		EndUnderline();
		break;
	      case TAG_HANDLE :
		length -= *line + 1;	/* key length plus length tag */
		if(handles){
		    int  key, n;

		    for(key = 0, n = *line++; n; n--) /* forget Horner? */
		      key = (key * 10) + (*line++ - '0');

#if	_WINDOWS
		    hkey = key;
#endif

		    if(key == handles->key){
			if(pico_usingcolor() &&
			   ps_global->VAR_SLCTBL_FORE_COLOR &&
			   ps_global->VAR_SLCTBL_BACK_COLOR){
			    pico_set_normal_color();
			}
			else
			  EndBold();

			StartInverse();
		    }
		}
		else{
		    /* BUG: complain? */
		    line += *line + 1;
		}

		break;
	      case TAG_FGCOLOR :
		if(length < RGBLEN){
		    Writechar(TAG_EMBED, 0);
		    Writechar(*(line-1), 0);
		    break;
		}

		(void)pico_set_fg_color(line);
		length -= RGBLEN;
		line += RGBLEN;
		break;
	      case TAG_BGCOLOR :
		if(length < RGBLEN){
		    Writechar(TAG_EMBED, 0);
		    Writechar(*(line-1), 0);
		    break;
		}

		(void)pico_set_bg_color(line);
		length -= RGBLEN;
		line += RGBLEN;
		break;
	      default :		/* literal "embed" char? */
		Writechar(TAG_EMBED, 0);
		Writechar(*(line-1), 0);
		break;
	    }					/* tag with handle, skip it */
	}	
	else if(c == '\033')			/* check for iso-2022 escape */
	  Writechar(c, match_escapes(line));
	else
	  Writechar(c, 0);
    }


#if	_WINDOWS_X
    if(hkey) {
	char *tmp_file = NULL, ext[32], mtype[128];
	HANDLE_S *h;
	extern HANDLE_S *get_handle (HANDLE_S *, int);

	if((h = get_handle(handles, hkey)) && h->type == Attach){
	    ext[0] = '\0';
	    strcpy(mtype, body_type_names(h->h.attach->body->type));
	    if (h->h.attach->body->subtype) {
		strcat (mtype, "/");
		strcat (mtype, h->h.attach->body->subtype);
	    }

	    if(!set_mime_extension_by_type(ext, mtype)){
		char *namep, *dotp, *p;

		if(namep = rfc2231_get_param(h->h.attach->body->parameter,
					     "name", NULL, NULL)){
		    for(dotp = NULL, p = namep; *p; p++)
		      if(*p == '.')
			dotp = p + 1;

		    if(dotp && strlen(dotp) < sizeof(ext) - 1)
		      strcpy(ext, dotp);

		    fs_give((void **) &namep);
		}
	    }

	    if(ext[0] && (tmp_file = temp_nam_ext(NULL, "im", ext))){
		FILE *f = fopen(tmp_file, "w");

		mswin_registericon(x, h->key, tmp_file);

		fclose(f);
		unlink(tmp_file);
		fs_give((void **)&tmp_file);
	    }
	}
    }
#endif
}


/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 1 arg

 Input:  position on the screen
         line of text to output

 Result: text is output
         cursor position is update
  ----------------------------------------------------------------------*/
void
/*VARARGS2*/
PutLine1(x, y, line, arg1)
    int   x, y;
    char *line;
    void *arg1;
{
    char buffer[PUTLINE_BUFLEN];

    sprintf(buffer, line, arg1);
    PutLine0(x, y, buffer);
}


/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 2 args

 Input:  position on the screen
         line of text to output

 Result: text is output
         cursor position is update
  ----------------------------------------------------------------------*/
void
/*VARARGS3*/
PutLine2(x, y, line, arg1, arg2)
    int   x, y;
    char *line;
    void *arg1, *arg2;
{
    char buffer[PUTLINE_BUFLEN];

    sprintf(buffer, line, arg1, arg2);
    PutLine0(x, y, buffer);
}


/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 3 args

 Input:  position on the screen
         line of text to output

 Result: text is output
         cursor position is update
  ----------------------------------------------------------------------*/
void
/*VARARGS4*/
PutLine3(x, y, line, arg1, arg2, arg3)
    int   x, y;
    char *line;
    void *arg1, *arg2, *arg3;
{
    char buffer[PUTLINE_BUFLEN];

    sprintf(buffer, line, arg1, arg2, arg3);
    PutLine0(x, y, buffer);
}


/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 4 args

 Args:  x -- column position on the screen
        y -- column position on the screen
        line -- printf style line of text to output

 Result: text is output
         cursor position is update
  ----------------------------------------------------------------------*/
void
/*VARARGS5*/
PutLine4(x, y, line, arg1, arg2, arg3, arg4)
     int   x, y;
     char *line;
     void *arg1, *arg2, *arg3, *arg4;
{
    char buffer[PUTLINE_BUFLEN];

    sprintf(buffer, line, arg1, arg2, arg3, arg4);
    PutLine0(x, y, buffer);
}



/*----------------------------------------------------------------------
      Printf style output line to the screen at given position, 5 args

 Args:  x -- column position on the screen
        y -- column position on the screen
        line -- printf style line of text to output

 Result: text is output
         cursor position is update
  ----------------------------------------------------------------------*/
void
/*VARARGS6*/
PutLine5(x, y, line, arg1, arg2, arg3, arg4, arg5)
     int   x, y;
     char *line;
     void *arg1, *arg2, *arg3, *arg4, *arg5;
{
    char buffer[PUTLINE_BUFLEN];

    sprintf(buffer, line, arg1, arg2, arg3, arg4, arg5);
    PutLine0(x, y, buffer);
}



/*----------------------------------------------------------------------
       Output a line to the screen, centered

  Input:  Line number to print on, string to output
  
 Result:  String is output to screen
          Returns column number line is output on
  ----------------------------------------------------------------------*/
int
Centerline(line, string)
    int   line;
    char *string;
{
    register int length, col;

    length = strlen(string);

    if (length > ps_global->ttyo->screen_cols)
      col = 0;
    else
      col = (ps_global->ttyo->screen_cols - length) / 2;

    PutLine0(line, col, string);
    return(col);
}



/*----------------------------------------------------------------------
     Clear specified line on the screen

 Result: The line is blanked and the cursor is left at column 0.

  ----*/
void
ClearLine(n)
    int n;
{
    if(ps_global->in_init_seq)
      return;

    MoveCursor(n, 0);
    CleartoEOLN();
}



/*----------------------------------------------------------------------
     Clear specified lines on the screen

 Result: The lines starting at 'x' and ending at 'y' are blanked
	 and the cursor is left at row 'x', column 0

  ----*/
void
ClearLines(x, y)
    int x, y;
{
    int i;

    for(i = x; i <= y; i++)
      ClearLine(i);

    MoveCursor(x, 0);
}



/*----------------------------------------------------------------------
    Indicate to the screen painting here that the position of the cursor
 has been disturbed and isn't where these functions might think.
 ----*/
void
clear_cursor_pos()
{
    _line = FARAWAY;
    _col  = FARAWAY;
}


