# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tse3/tse3-0.2.5.ebuild,v 1.6 2005/09/04 12:18:09 flameeyes Exp $

DESCRIPTION="TSE3 Sequencer library"
HOMEPAGE="http://TSE3.sourceforge.net/"
SRC_URI="mirror://sourceforge/tse3/${P}.tar.gz"

KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="alsa oss arts"

DEPEND="alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )"

src_compile() {
	local myconf=""

	use arts || myconf="$myconf --without-arts"
	use alsa || myconf="$myconf --without-alsa"
	use oss || myconf="$myconf --without-oss"
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$myconf || die "./configure failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO Version
}
