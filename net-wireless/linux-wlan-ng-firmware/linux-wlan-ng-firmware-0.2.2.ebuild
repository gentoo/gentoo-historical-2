# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/linux-wlan-ng-firmware/linux-wlan-ng-firmware-0.2.2.ebuild,v 1.2 2005/10/02 09:17:56 betelgeuse Exp $

inherit eutils

MY_P=${P/-firmware/}

DESCRIPTION="Firmware for Prism2/2.5/3 based 802.11b wireless LAN products"
HOMEPAGE="http://linux-wlan.org"
SRC_URI="ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/${MY_P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/prism2_makefile-${PV}.patch
}

src_compile() {
	local config=${S}/config.mk
	echo TARGET_ROOT_ON_HOST=${D} >> ${config}
	echo FIRMWARE_DIR=/lib/firmware >> ${config}
}

src_install() {
	cd ${S}/src/prism2
	make install-firmware || die "Failed to install firmware"
}

pkg_postinst() {
	einfo "Firmware location has changed to ${ROOT}lib/firmware."
	einfo "You can run ebuild <ebuild> config to delete"
	einfo "The old files. Because of the default configuration file"
	einfo "protection the files are most likely left your system"
	einfo "and are now useless."
}

pkg_config() {
	rm -i ${ROOT}/etc/wlan/*.hex
	rm -i ${ROOT}/etc/wlan/*.pda
}
