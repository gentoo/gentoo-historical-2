# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/apachetop/apachetop-0.9.ebuild,v 1.1 2003/12/24 17:42:27 stuart Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A realtime Apache log analyzer"
HOMEPAGE="http://clueful.shagged.org/apachetop/"
SRC_URI="http://clueful.shagged.org/apachetop/files/${P}.tar.gz"

IUSE="apache2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"

DEPEND="!apache2? ( >=net-www/apache-1.3.28 )
	apache2? ( >=net-www/apache-2.0.47 )
	sys-apps/sed"

src_compile() {
	if use apache2
	then
		sed -i 's%DEFAULT_LOGFILE "/var/httpd/apache_log"%DEFAULT_LOGFILE "/etc/apache2/logs/access_log"%' src/apachetop.h
	else
		sed -i 's%DEFAULT_LOGFILE "/var/httpd/apache_log"%DEFAULT_LOGFILE "/etc/apache/logs/access_log"%' src/apachetop.h
	fi
	./configure
	emake || die
}

src_install() {
	dobin src/apachetop || die

	dodoc README INSTALL TODO AUTHORS ChangeLog NEWS
}
