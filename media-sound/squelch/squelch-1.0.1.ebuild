# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/squelch/squelch-1.0.1.ebuild,v 1.14 2006/01/07 19:21:25 carlo Exp $

inherit kde

IUSE=""

DESCRIPTION="qt-based Ogg Vorbis player"
HOMEPAGE="http://rikkus.info/squelch.html"
SRC_URI="http://rikkus.info/arch/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"

DEPEND="media-libs/libvorbis
	media-libs/libao"
need-qt 3

src_compile() {
	./configure --prefix=/usr
	make || die "Make failed"
}

src_install() {
	dobin src/squelch
	dodoc AUTHORS README THANKS
}
