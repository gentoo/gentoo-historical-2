# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/atmel-firmware/atmel-firmware-1.1.ebuild,v 1.2 2005/03/24 20:09:43 blubb Exp $

inherit toolchain-funcs

DESCRIPTION="Firmware and config for atmel and atmel_cs wlan drivers included in linux 2.6"
HOMEPAGE="http://www.thekelleys.org.uk/atmel/"
SRC_URI="http://www.thekelleys.org.uk/atmel/${P}.tar.gz"
LICENSE="Atmel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="pcmcia usb"

RDEPEND=">=sys-apps/hotplug-20040923
		>=net-wireless/wireless-tools-26-r1
		pcmcia? ( sys-apps/pcmcia-cs )"

src_compile() {
	$(tc-getCC) -o atmel_fwl atmel_fwl.c
}

src_install() {
	insinto /lib/firmware
	doins images/*.bin
	if use usb; then
		doins images.usb/*.bin
	fi

	if use pcmcia; then
		insinto /etc/pcmcia
		doins atmel.conf
	fi

	dosbin atmel_fwl atmel_fwl.pl
	doman atmel_fwl.8
	dodoc README COPYING VERSION
}

pkg_postinst() {
	if use pcmcia && [ -f /var/run/cardmgr.pid ]; then
		kill -HUP `cat /var/run/cardmgr.pid`
	fi
}

pkg_postrm() {
	if use pcmcia && [ -f /var/run/cardmgr.pid ]; then
		kill -HUP `cat /var/run/cardmgr.pid`
	fi
}
