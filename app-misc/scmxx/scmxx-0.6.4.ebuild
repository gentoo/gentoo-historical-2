# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/scmxx/scmxx-0.6.4.ebuild,v 1.4 2004/06/24 22:32:24 agriffis Exp $

DESCRIPTION="Exchange data with Siemens phones."
HOMEPAGE="http://www.hendrik-sattler.de/scmxx/"
SRC_URI="mirror://sourceforge/scmxx/${P}.tar.bz2"
DEPEND="virtual/glibc"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	exeinto /usr/lib/scmxx
	doexe contrib/*
	dodoc AUTHORS BUGS CHANGELOG INSTALL README TODO VERSION docs/*.txt
	newdoc docs/README README.doc
}
