# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/obpager/obpager-1.8.ebuild,v 1.1.1.1 2005/11/30 09:40:24 chriswhite Exp $

DESCRIPTION="Lightweight pager designed to be used with NetWM-compliant window manager"
HOMEPAGE="http://obpager.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha x86"
IUSE=""

DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}

	# this makes it compile :-)
	sed -i -e '18s/^.*$/#include <errno.h>/' src/main.cc
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin obpager
	dodoc README
}
