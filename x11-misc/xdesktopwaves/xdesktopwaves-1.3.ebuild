# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdesktopwaves/xdesktopwaves-1.3.ebuild,v 1.6 2008/03/23 17:03:30 nixnut Exp $

inherit eutils

DESCRIPTION="A cellular automata setting the background of your X Windows desktop under water"
HOMEPAGE="http://xdesktopwaves.sourceforge.net/"
LICENSE="GPL-2"
RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE=""

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

src_compile() {
	emake || die "failed building program"
	cd xdwapi
	emake || die "failed building demo"
}

src_install() {
	dobin xdesktopwaves xdwapi/xdwapidemo
	doman xdesktopwaves.1
	insinto /usr/share/pixmaps
	doins xdesktopwaves.xpm
	make_desktop_entry xdesktopwaves "xdesktopwaves" xdesktopwaves.xpm
	dodoc README
}

pkg_preinst() {
	elog "To see what xdesktopwaves is able to do, start it by running"
	elog "'xdesktopwaves' and then run 'xdwapidemo'. You should see the"
	elog "supported effects on your desktop"
}
