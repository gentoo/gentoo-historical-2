# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpixman/libpixman-0.1.1.ebuild,v 1.5 2004/07/01 07:59:43 eradicator Exp $

DESCRIPTION="A generic library for manipulating pixel regions"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"
LICENSE="X11"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make install DESTDIR=${D}
}
