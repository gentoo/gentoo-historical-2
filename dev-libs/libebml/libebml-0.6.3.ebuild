# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libebml/libebml-0.6.3.ebuild,v 1.7 2004/07/10 23:12:52 weeve Exp $

inherit flag-o-matic

IUSE=""

S=${WORKDIR}/${P}

DESCRIPTION="Extensible binary format library (kinda like XML)"
SRC_URI="http://matroska.free.fr/downloads/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.matroska.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~amd64 alpha ia64 sparc"

DEPEND="virtual/libc"

src_compile() {
	cd ${S}/make/linux
	sed -i -e 's/CXXFLAGS=/CXXFLAGS+=/g' Makefile
	make PREFIX=/usr || die "make failed"
}

src_install () {
	cd ${S}/make/linux
	einstall || die "make install failed"
	dodoc ${S}/LICENSE.*
}

