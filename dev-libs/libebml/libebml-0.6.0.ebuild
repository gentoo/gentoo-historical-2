# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libebml/libebml-0.6.0.ebuild,v 1.8 2005/04/24 20:23:24 flameeyes Exp $

inherit flag-o-matic

IUSE=""

S=${WORKDIR}/${PN}

DESCRIPTION="Extensible binary format library (kinda like XML)"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/old/${P}.tar.bz2"
HOMEPAGE="http://www.matroska.org"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc amd64"

DEPEND="virtual/libc"

src_compile() {
	cd ${S}/make/linux
	make PREFIX=/usr || die "make failed"
}

src_install () {
	cd ${S}/make/linux
	einstall || die "make install failed"
	dodoc ${S}/LICENSE.*
}
