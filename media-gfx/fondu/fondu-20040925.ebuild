# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fondu/fondu-20040925.ebuild,v 1.1 2004/10/09 20:39:27 usata Exp $

DESCRIPTION="Utilities for converting between and manipulating mac fonts and unix fonts"
HOMEPAGE="http://fondu.sourceforge.net/"
# 20040527 -> 040527
SRC_URI="mirror://sourceforge/${PN}/${PN}_src-${PV:2:6}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE=""
DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	dodir /usr/bin
	einstall || die "make install failed"

	dodoc README
}
