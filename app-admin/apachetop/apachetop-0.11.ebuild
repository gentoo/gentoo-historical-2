# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/apachetop/apachetop-0.11.ebuild,v 1.5 2004/07/09 19:42:16 stuart Exp $

DESCRIPTION="A realtime Apache log analyzer"
HOMEPAGE="http://clueful.shagged.org/apachetop/"
SRC_URI="http://clueful.shagged.org/apachetop/files/${P}.tar.gz"

IUSE="apache2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~mips"

DEPEND="!apache2? ( >=net-www/apache-1.3.28 )
	apache2? ( >=net-www/apache-2.0.47 )
	sys-apps/sed
	sys-libs/libtermcap-compat"

src_compile() {
	if use apache2
	then
		sed -i 's%DEFAULT_LOGFILE "/var/httpd/apache_log"%DEFAULT_LOGFILE "/var/log/apache2/access_log"%' src/apachetop.h
	else
		sed -i 's%DEFAULT_LOGFILE "/var/httpd/apache_log"%DEFAULT_LOGFILE "/var/log/access_log"%' src/apachetop.h
	fi
	./configure
	sed -i 's/-lcurses/-lncurses/' src/Makefile
	emake || die
}

src_install() {
	dobin src/apachetop || die

	dodoc README INSTALL TODO AUTHORS ChangeLog NEWS
}
