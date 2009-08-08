# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dvda-author/dvda-author-09.05.ebuild,v 1.4 2009/08/08 13:18:08 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="Author a DVD-Audio DVD"
HOMEPAGE="http://dvd-audio.sourceforge.net"
SRC_URI="mirror://sourceforge/dvd-audio/${P}-3.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/sox-14.1[png]
	>=media-libs/flac-1.2.1[ogg]"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sandbox.patch
	AT_NO_RECURSIVE="yes" eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-ogg-flac \
		--with-config=/etc
}

src_install() {
	newbin src/dvda ${PN} || die "newbin failed"
	insinto /etc
	doins ${PN}.conf || die "doins failed"
	dodoc AUTHORS BUGS
	doicon ${PN}.png
}
