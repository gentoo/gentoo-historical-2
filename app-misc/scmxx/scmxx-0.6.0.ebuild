# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: ?yvind Repvik <nail@dataparty.no>
# $Header: /var/cvsroot/gentoo-x86/app-misc/scmxx/scmxx-0.6.0.ebuild,v 1.1 2002/05/03 00:04:12 agenkin Exp $

DESCRIPTION="Exchange data with Siemens phones."
HOMEPAGE="http://www.hendrik-sattler.de/scmxx/"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

SRC_URI="http://ma2geo.mathematik.uni-karlsruhe.de/~hendrik/scmxx/download/${P}.tar.bz2"
S=${WORKDIR}/${P}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		|| die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	exeinto /usr/lib/scmxx
	doexe contrib/*
	dodoc AUTHORS BUGS CHANGELOG INSTALL README TODO VERSION docs/*.txt
	newdoc docs/README README.doc
}
