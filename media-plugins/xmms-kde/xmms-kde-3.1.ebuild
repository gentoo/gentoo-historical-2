# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-kde/xmms-kde-3.1.ebuild,v 1.2 2005/01/25 20:30:07 eradicator Exp $

inherit kde eutils

DESCRIPTION="xmms-kde is a MP3 player integrated into the KDE panel. It can also be used to control XMMS and Noatun from the panel."
HOMEPAGE="http://xmms-kde.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmms-kde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="xmms sdl"

DEPEND="xmms? ( >=media-sound/xmms-1.2.7-r23 )
	sdl? ( >=media-libs/smpeg-0.4.4-r4 )
	kde-base/arts"

need-kde 3.1

src_compile() {
	myconf="--disable-gtk-test"

	kde_src_compile
}

src_install() {
	kde_src_install

	dodoc MISSING VERSION
}
