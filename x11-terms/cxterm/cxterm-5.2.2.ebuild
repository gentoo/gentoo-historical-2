# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/cxterm/cxterm-5.2.2.ebuild,v 1.6 2004/02/28 21:29:28 aliz Exp $

S="${WORKDIR}/${P}"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://cxterm.sourceforge.net/"
DESCRIPTION="A Chinese/Japanese/Korean X-Terminal"

DEPEND="virtual/x11"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

# hyper-optimizations untested...
#
src_compile() {

	cd ${S}
	sed -i "s/genCxterm/\.\/genCxterm/g" ${S}/scripts/Makefile.in

	./configure --prefix=/usr \
				--mandir=/usr/share/man \
				--infodir=/usr/share/info || die "./configure failed"

	make CFLAGS="${CFLAGS}" || die

}

src_install() {

	emake \
			prefix=${D}/usr \
			mandir=${D}/usr/share/man \
			infodir=${D}/usr/share/info \
			install || die

	dodoc README-5.2 INSTALL-5.2 Doc/*
	docinto tutorial-1
	dodoc Doc/tutorial-1/*
	docinto tutorial-2
	dodoc Doc/tutorial-2/*
}
