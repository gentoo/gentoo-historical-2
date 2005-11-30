# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/temperature-app/temperature-app-1.4.ebuild,v 1.1 2003/12/13 23:38:00 port001 Exp $

IUSE=""

MY_PN=${PN/-/.}
MY_PN=${MY_PN/t/T}
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Temperature.app is a Window Maker dockapp to display the local temperature in either celsius or farenheit."
SRC_URI="http://www.fukt.bth.se/~per/temperature/${MY_PN}-${PV}.tar.gz"
HOMEPAGE="http://www.fukt.bth.se/~per/temperature/"

DEPEND="virtual/x11
	net-misc/wget
	media-libs/xpm"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_compile() {
	emake || die "make failed"
}

src_install () {
	dobin Temperature.app
	dodoc COPYING README INSTALL ChangeLog
}
