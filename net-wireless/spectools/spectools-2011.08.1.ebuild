# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/spectools/spectools-2011.08.1.ebuild,v 1.2 2012/05/22 16:38:30 ssuominen Exp $

EAPI=4

inherit toolchain-funcs eutils

MY_P=${P/\./-}
MY_P=${MY_P/./-R}
S=${WORKDIR}/${MY_P}

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="http://www.kismetwireless.net/spectools/"

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://www.kismetwireless.net/code/svn/tools/spectools"
		inherit subversion
		KEYWORDS=""
else
		SRC_URI="http://www.kismetwireless.net/code/${MY_P}.tar.gz"
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug ncurses gtk"

DEPEND="${RDEPEND}"
RDEPEND="virtual/libusb
	ncurses? ( sys-libs/ncurses )
	gtk? ( =x11-libs/gtk+-2* )"

src_compile() {
	emake depend

	if use debug; then
		emake spectool_raw
	fi

	if use ncurses; then
		emake spectool_curses
	fi

	if use gtk; then
		emake spectool_gtk
	fi

	emake spectool_net

}

src_install() {
	dobin spectool_net
	use debug && dobin spectool_raw
	use ncurses && dobin spectool_curses
	use gtk && dobin spectool_gtk

	dodir /$(get_libdir)/udev/rules.d/
	insinto /$(get_libdir)/udev/rules.d/
	doins 99-wispy.rules
	dodoc README
}
