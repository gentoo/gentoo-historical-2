# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/nail/nail-9.30.ebuild,v 1.5 2004/07/14 16:24:24 agriffis Exp $

DESCRIPTION="Nail is a mail user agent derived from Berkeley Mail 8.1 and contains builtin support for MIME messages."
SRC_URI="http://omnibus.ruf.uni-freiburg.de/~gritter/archive/nail/${P}.tar.gz"
HOMEPAGE="http://omnibus.ruf.uni-freiburg.de/~gritter/"

DEPEND="virtual/libc"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

src_compile() {
	econf \
		--with-mailspool=~/.maildir || die "configure failed"

	emake || die "emake failed"
}

src_install () {
	#add smtp flag to nail.rc so that it uses smtp by default (making it
	#essentially mailer independent
	echo -e "\n#use smtp on the local system by default.  Change" >> nail.rc
	echo -e "#\"localhost\" to your smtp server if you use a remote" >> nail.rc
	echo -e "#smtp server.  (Delete this line to use sendmail instead)" >> nail.rc
	echo -e "set smtp=localhost" >> nail.rc

	make DESTDIR=${D} install || die "install failed"
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
