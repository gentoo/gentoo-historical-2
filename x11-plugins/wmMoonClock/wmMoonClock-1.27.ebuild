# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmMoonClock/wmMoonClock-1.27.ebuild,v 1.13 2006/01/22 11:55:13 nelchael Exp $

IUSE=""
DESCRIPTION="dockapp that shows lunar ephemeris to a high accuracy."
SRC_URI="http://nis-www.lanl.gov/~mgh/WindowMaker/${P}.tar.gz"
HOMEPAGE="http://nis-www.lanl.gov/~mgh/WindowMaker/DockApps.shtml"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( (
		x11-proto/xproto
		x11-proto/xextproto )
	virtual/x11 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~mips ppc ~sparc"

src_unpack() {
	unpack ${A} ; cd ${S}/Src
	sed -i -e "s:-O2:${CFLAGS}:" Makefile
}

src_compile() {
	emake -C Src || die "parallel make failed"
}

src_install () {
	dobin Src/wmMoonClock
	doman Src/wmMoonClock.1
	dodoc BUGS
}
