# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmodplug/libmodplug-0.7.ebuild,v 1.13 2006/02/06 20:52:08 flameeyes Exp $

inherit eutils

DESCRIPTION="Library for playing MOD-like music files"
SRC_URI="mirror://sourceforge/modplug-xmms/${P}.tar.gz"
HOMEPAGE="http://modplug-xmms.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
#-sparc: 1.0 - Bus Error on play
KEYWORDS="amd64 arm ia64 ppc ~ppc64 sh -sparc x86"
IUSE=""

RDEPEND=""
DEPEND="dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"/src/libmodplug
	epatch "${FILESDIR}"/${P}-amd64.patch
	cd ${S}
	epatch "${FILESDIR}/${P}-asneeded.patch"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
}
