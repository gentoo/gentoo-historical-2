# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/guile-pg/guile-pg-0.15.ebuild,v 1.3 2004/06/24 23:59:36 agriffis Exp $

IUSE=""

DESCRIPTION="Guile bindings for PostgreSQL"
SRC_URI="http://www.glug.org/alt/${P}.tar.gz"
HOMEPAGE="http://www.glug.org/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND="virtual/glibc
		dev-db/postgresql
		dev-util/guile"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	einstall || die
	rm -f ${D}/usr/info/dir
	dodoc COPYING HACKING INSTALL NEWS README TODO AUTHORS ChangeLog
}

