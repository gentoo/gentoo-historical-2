# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-util/ddd/ddd-3.3.1-r1.ebuild,v 1.3 2002/07/23 10:38:07 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU DDD is a graphical front-end for command-line debuggers"
HOMEPAGE="http://www.gnu.org/software/ddd"
SRC_URI="ftp://ftp.easynet.be/gnu/ddd/${P}.tar.gz
	ftp://ftp.easynet.be/gnu/ddd/${P}-html-manual.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1 FDL-1.1"
KEYWORDS="x86"

DEPEND="virtual/x11
	>=sys-devel/gdb-4.16
	>=x11-libs/openmotif-2.1.30"
	
src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	
	mv ${S}/doc/README ${S}/doc/README-DOC
	dodoc ANNOUNCE AUTHORS BUGS COPYING* CREDITS INSTALL NEWS* NICKNAMES \
		OPENBUGS PROBLEMS README* TIPS TODO
	
	mv ${S}/doc/* ${D}/usr/share/doc/${PF}
}
