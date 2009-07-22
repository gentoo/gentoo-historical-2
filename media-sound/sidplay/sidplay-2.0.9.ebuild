# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sidplay/sidplay-2.0.9.ebuild,v 1.11 2009/07/22 21:01:53 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="C64 SID player"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sidplay2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libsidplay-2.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc44.patch
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO AUTHORS ChangeLog
}
