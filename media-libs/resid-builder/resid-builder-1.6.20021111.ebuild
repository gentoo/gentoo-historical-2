# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/resid-builder/resid-builder-1.6.20021111.ebuild,v 1.1 2002/11/11 18:34:22 hanno Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="resid builder - required by sidplay"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="http://www-ti.informatik.uni-tuebingen.de/~bwurst/${P}.tar.bz2"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=media-libs/resid-0.13-r1"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
