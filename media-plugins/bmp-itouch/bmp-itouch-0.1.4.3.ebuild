# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/bmp-itouch/bmp-itouch-0.1.4.3.ebuild,v 1.1 2004/10/01 19:11:05 chainsaw Exp $

IUSE=""

DESCRIPTION="BMP plugin for the extra keys on multimedia keyboards"
HOMEPAGE="http://bmp-itouch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="media-sound/beep-media-player
	sys-devel/autoconf
	dev-util/pkgconfig"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	einfo "To configure the multimedia keys on your keyboard for use with"
	einfo "BMP, enable this plugin within BMP and choose a keyboard model"
	einfo "from the list. You can also \"grab\" keys within this"
	einfo "configuration screen. However, for complete freedom of choice "
	einfo "xev is your friend :-)"
}
