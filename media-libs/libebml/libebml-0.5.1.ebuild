# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libebml/libebml-0.5.1.ebuild,v 1.1 2003/09/09 20:13:33 mholzer Exp $

IUSE=""

S=${WORKDIR}/${PN}

DESCRIPTION="Extensible binary format library (kinda like XML)"
SRC_URI="http://matroska.free.fr/downloads/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.matroska.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/glibc"

src_compile() {
	cd ${S}/make/linux
	make PREFIX=/usr || die "make failed"
}

src_install () {
	cd ${S}/make/linux
	einstall || die "make install failed"
}
