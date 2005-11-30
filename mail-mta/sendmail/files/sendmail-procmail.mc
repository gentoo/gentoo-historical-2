divert(-1)
divert(0)dnl
include(`/usr/share/sendmail-cf/m4/cf.m4')dnl
VERSIONID(`$Id: sendmail-procmail.mc,v 1.1.1.1 2005/11/30 09:50:52 chriswhite Exp $')dnl
OSTYPE(linux)dnl
DOMAIN(generic)dnl
FEATURE(`smrsh',`/usr/sbin/smrsh')dnl
FEATURE(`local_lmtp',`/usr/sbin/mail.local')dnl
FEATURE(`local_procmail')dnl
MAILER(local)dnl
MAILER(smtp)dnl
MAILER(procmail)dnl
