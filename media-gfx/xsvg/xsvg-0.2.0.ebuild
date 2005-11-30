# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xsvg/xsvg-0.2.0.ebuild,v 1.1.1.1 2005/11/30 09:37:39 chriswhite Exp $

DESCRIPTION="X11 SVG viewer"
HOMEPAGE="http://xsvg.org/"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/x11
	>=x11-libs/libsvg-cairo-0.1.5"

src_install() {
	make install DESTDIR=${D} || die
}
