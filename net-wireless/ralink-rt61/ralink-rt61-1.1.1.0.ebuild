# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ralink-rt61/ralink-rt61-1.1.1.0.ebuild,v 1.1 2007/08/29 19:32:07 genstef Exp $

inherit eutils linux-mod

DESCRIPTION="Driver for the RaLink RT61 wireless chipset"
HOMEPAGE="http://www.ralinktech.com/"
LICENSE="GPL-2"

MY_P=${P/${PN}-/IS_Linux_STA_6x_D_}

SRC_URI="http://www.ralinktech.com.tw/data/${MY_P}.tar.gz"

KEYWORDS="-* amd64 x86"
IUSE=""
SLOT="0"

DEPEND=""
RDEPEND="net-wireless/wireless-tools
	!net-wireless/rt61"

S="${WORKDIR}/${MY_P}"

MODULE_NAMES="rt61(net:${S}/Module)"
BUILD_TARGETS=" "
MODULESD_RT61_ALIASES=('ra? rt61')

CONFIG_CHECK="WIRELESS_EXT"
ERROR_WIRELESS_EXT="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_WIRELESS_EXT)."

src_compile() {
	epatch ${FILESDIR}/rtmp_main.diff
	if kernel_is 2 6; then
		cp Module/Makefile.6 Module/Makefile
	elif kernel_is 2 4; then
		cp Module/Makefile.4 Module/Makefile
	else
		die "Your kernel version is not supported!"
	fi

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodoc Module/{ReleaseNote,STA_iwpriv_ATE_usage.txt,README,iwpriv_usage.txt}

	insinto /etc/Wireless/RT61STA
	insopts -m 0600
	doins Module/rt61sta.dat
	insopts -m 0644
	doins Module/{rt2561,rt2561s,rt2661}.bin
}
