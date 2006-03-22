# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/logitech-applet/logitech-applet-0.4_pre1-r1.ebuild,v 1.1 2006/03/22 12:35:11 r3pek Exp $

inherit eutils

MY_P=${P/_pre/test}
MY_P=${MY_P/-applet/_applet}

DESCRIPTION="Control utility for some special features of some special
			Logitech USB mice!"
HOMEPAGE="http://freshmeat.net/projects/logitech_applet/"
SRC_URI="http://www.frogmouth.net/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	dev-libs/libusb"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/logitech_applet-mx518.patch" || die "Failed to apply
		patch"
}

src_install() {
	dosbin logitech_applet
	dodoc AUTHORS ChangeLog README doc/article.txt
}
