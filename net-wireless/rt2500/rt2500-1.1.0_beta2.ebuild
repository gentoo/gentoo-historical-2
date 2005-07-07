# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rt2500/rt2500-1.1.0_beta2.ebuild,v 1.4 2005/07/07 05:02:30 caleb Exp $

inherit eutils linux-mod kde-functions
set-qtdir 3

MY_P="${P/_beta/-b}"
DESCRIPTION="Driver for the RaLink RT2500 wireless chipset"
HOMEPAGE="http://rt2x00.serialmonkey.com"
SRC_URI="http://rt2x00.serialmonkey.com/${MY_P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~x86 ~amd64"
IUSE="qt"
DEPEND="net-wireless/wireless-tools
	qt? ( =x11-libs/qt-3* )"

S=${WORKDIR}/${MY_P/-b*}
MODULE_NAMES="rt2500(net:${S}/Module)"
CONFIG_CHECK="NET_RADIO"
MODULESD_RT2500_ALIASES=('ra? rt2500')


pkg_setup() {
	linux-mod_pkg_setup
	if use_m
	then BUILD_PARAMS="-C ${KV_DIR} M=${S}/Module"
		 BUILD_TARGETS="modules"
	else die "please use a kernel >=2.6.6"
	fi
}

src_compile() {
	if useq qt; then
		cd ${S}/Utilitys
		${QTDIR}/bin/qmake -o Makefile raconfig2500.pro
		emake || die "make Utilities failed"
	fi

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	useq qt && dobin ${S}/Utilitys/RaConfig2500

	dodoc Module/README Module/iwpriv_usage.txt LICENSE FAQ CHANGELOG
}
