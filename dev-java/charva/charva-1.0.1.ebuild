# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/charva/charva-1.0.1.ebuild,v 1.4 2004/06/27 17:00:53 zx Exp $

inherit java-pkg

DESCRIPTION="A Java Windowing Toolkit for Text Terminals"
SRC_URI="http://www.pitman.co.za/projects/charva/download/${P}.tar.gz"
HOMEPAGE="http://www.pitman.co.za/projects/charva/"
IUSE="doc"
DEPEND="virtual/glibc
		>=virtual/jdk-1.3
		sys-libs/ncurses"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

src_unpack() {
	unpack ${A}
	rm ${S}/c/src/libTerminal.so
}

src_compile() {
	cd c/src
	make -f Makefile.linux

	cd ${S}/java/src
	make
}

src_install () {
	cd ${S}
	dolib.so c/src/*.so
	java-pkg_dojar java/lib/${PN}.jar
	use doc && dohtml -r java/doc
	dodoc README
}
