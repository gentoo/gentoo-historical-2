# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xsvg/xsvg-0.2.0.ebuild,v 1.3 2006/02/11 16:10:08 joshuabaergen Exp $

DESCRIPTION="X11 SVG viewer"
HOMEPAGE="http://xsvg.org/"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RDEPEND=">=x11-libs/libsvg-cairo-0.1.5"
DEPEND="${RDEPEND}
	|| ( ( x11-libs/libXt
			x11-libs/libXcursor )
		virtual/x11 )"

src_install() {
	make install DESTDIR=${D} || die
}
