# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kismet/kismet-2006.04.1.ebuild,v 1.9 2007/01/31 18:10:39 phreak Exp $

inherit toolchain-funcs linux-info

MY_P=${P/\./-}
MY_P=${MY_P/./-R}
S=${WORKDIR}/${MY_P}

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="http://www.kismetwireless.net/"
SRC_URI="http://www.kismetwireless.net/code/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ncurses"

RDEPEND="net-wireless/wireless-tools
		ncurses? ( sys-libs/ncurses )"
DEPEND="${RDEPEND}
		>=sys-devel/autoconf-2.58
		sys-apps/sed"

src_unpack() {
	unpack ${A}

	sed -i -e "s:^\(logtemplate\)=\(.*\):\1=/tmp/\2:" \
		"${S}"/conf/kismet.conf.in

	# Remove -s from install options
	sed -i -e 's| -s||g' "${S}"/Makefile.in
}

src_compile() {
	# the configure script only honors '--disable-foo'
	local config="--disable-gpsmap"

	if ! use ncurses; then
		config="${config} --disable-curses --disable-panel"
	fi

	# need to set CC and CXX for FEATURES=confcache, bug #129479
	CC=$(tc-getCC) CXX=$(tc-getCXX) \
		econf \
		${config} --with-linuxheaders="${KV_DIR}" || die "econf failed"

	einfo "You may safely ignore the warning about the missing .depend file"
	emake dep || die "emake dep failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGELOG README TODO docs/*

	newinitd "${FILESDIR}"/${P}-init.d kismet
	newconfd "${FILESDIR}"/${P}-conf.d kismet
}
