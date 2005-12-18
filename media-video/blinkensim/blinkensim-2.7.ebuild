# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/blinkensim/blinkensim-2.7.ebuild,v 1.3 2005/12/18 23:23:47 chainsaw Exp $

DESCRIPTION="Graphical Blinkenlights simulator with networking support"

HOMEPAGE="http://www.blinkenlights.de/arcade/hack"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aalib gtk2 directfb"

# if the config script finds any of the optional library it will try to
# compile against it
DEPEND=">=media-libs/blib-1.1.4
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	gtk2? ( >=x11-libs/gtk+-2.4.4 )
	directfb? ( >=dev-libs/DirectFB-0.9.20-r1 )"
RDEPEND="media-video/blinkenthemes"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} \
		install || die "install failed"
}
