# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/nail/nail-9.27.ebuild,v 1.4 2002/07/11 06:30:47 drobbins Exp $

#Remeber to add the proper Author line, above.  Don't worry about the fourth line;
#it'll get automatically fixed when the ebuild is checked in.

#Source directory; the dir where the sources can be found (automatically unpacked)
#inside ${WORKDIR}
S=${WORKDIR}/${P}

#Short one-line description
DESCRIPTION="Nail is a mail user agent derived from Berkeley Mail 8.1 and contains builtin support for MIME messages."

#Point to any required sources; these will be automatically downloaded by Portage
SRC_URI="http://omnibus.ruf.uni-freiburg.de/~gritter/archive/nail/${P}.tar.gz"

#Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://omnibus.ruf.uni-freiburg.de/~gritter/"

#build-time dependencies
DEPEND="virtual/glibc"

#run-time dependencies, same as DEPEND if RDEPEND isn't defined:
#RDEPEND=""

src_compile() {
    #the "try" command will stop the build process if the specified command fails.  Prefix critical
	#commands with "try"
	#try ./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} --with-mailspool=/var/spool/mail
	try ./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} --with-mailspool=~/.maildir
    #Note the use of --infodir and --mandir, above.  This is to make this package FHS 2.2-compliant
	#(/usr/share is used for info and man now).
	
	try emake
	#emake (previously known as pmake) is a script that calls the standard GNU make with parallel
	#building options for speedier builds on SMP systems.  Use emake first; it make not work.  If
	#not, then replace the line above with:
	
	#try make
}

src_install () {
	#you must *personally verify* that this trick doesn't install
	#anything outside of DESTDIR; do this by reading and understanding
	#the install part of the Makefiles.  Also note that this will often
	#also work for autoconf stuff (usually much more often than DESTDIR,
	#which is actually quite rare.

    #add smtp flag to nail.rc so that it uses smtp by default (making it
    #essentially mailer independent
    echo -e "\n#use smtp on the local system by default.  Change" >> nail.rc
    echo -e "#\"localhost\" to your smtp server if you use a remote" >> nail.rc
    echo -e "#smtp server.  (Delete this line to use sendmail instead)" >> nail.rc
    echo -e "set smtp=localhost" >> nail.rc
	
	# try make prefix=${D}/usr install

    try make DESTDIR=${D} install
	#again, verify the Makefiles!  We don't want anything falling outside
	#of ${D}.
    dodoc AUTHORS COPYING I18N INSTALL README
    dodir /bin
    dosym /usr/bin/nail /bin/mail
    dosym /usr/bin/nail /usr/bin/mail
    dosym /usr/bin/nail /usr/bin/Mail
}

pkg_postinst () {

    echo -e "\nNOTE: The nail mailer does _not_ support maildir format.\n" \
              "      It is best to use nail only for outgoing mail, and\n" \
	      "      really only use it for scripts that require it.\n\n" \
	      "NOTE: This build has ~/.maildir compiled in as the\n" \
	      "      mail spool directory (for incoming mail).\n" \
	      "      Nail will work for sending outgoing mail even if\n" \
	      "      the mail spool directory does not exist.\n\n" \
	      "NOTE: When used to send mail via a remote smtp server\n" \
	      "      nail does not require a local mail transfer agent.\n" \
	      "      ISP smtp servers tend to have names like\n" \
	      "        mail.ispname.com\n" \
	      "      or\n" \
	      "        smtp.ispname.com.\n" \
	      "      If you do not wish to use a remote smtp server,\n" \
	      "      then you WILL have to install a mta such as sendmail,\n" \
	      "      postfix, exim, etcetera.\n"

}
