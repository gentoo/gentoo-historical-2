# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Grant Goodyear <g2boojum@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/squirrelmail/squirrelmail-1.2.4.ebuild,v 1.1 2002/01/28 23:18:42 g2boojum Exp $

S=${WORKDIR}/${P}
HTTPD_ROOT="/usr/local/httpd/htdocs"

DESCRIPTION="Webmail for nuts!"

SRC_URI="http://prdownloads.sf.net/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.squirrelmail.org"

DEPEND="dev-lang/php
        net-www/apache"

RDEPEND="virtual/imap"

src_compile() {
	#nothing to compile
	echo "Nothing to compile"
}

src_install () {
	dodir ${HTTPD_ROOT}/${P}
	dosym ${HTTPD_ROOT}/${P} ${HTTPD_ROOT}/${PN}
	cp -r . ${D}/${HTTPD_ROOT}/${P}
	cd ${D}/${HTTPD_ROOT}
	chown -R nobody.nobody ${P}
}

