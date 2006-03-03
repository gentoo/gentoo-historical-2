# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/acx/acx-0.3.35.ebuild,v 1.2 2006/03/03 03:59:08 tsunam Exp $

inherit linux-mod

DESCRIPTION="Driver for the ACX100 and ACX111 wireless chipset (CardBus, PCI, USB)"

HOMEPAGE="http://acx100.sourceforge.net/"
SRC_URI="http://acx100.erley.org/acx-20060215.tar.bz2"

LICENSE="GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="net-wireless/wireless-tools
	net-wireless/acx-firmware"

S=${WORKDIR}

MODULE_NAMES="acx(net:${S})"
CONFIG_CHECK="NET_RADIO FW_LOADER"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"
}

src_unpack() {
	unpack ${A}
	chmod ug+w . -R
	sed -i 's:usr/share/acx:lib/firmware:' common.c || die "sed failed"
}

src_install() {
	linux-mod_src_install

	dodoc README
}
