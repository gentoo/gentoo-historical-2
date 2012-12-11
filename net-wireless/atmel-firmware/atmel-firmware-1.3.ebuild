# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/atmel-firmware/atmel-firmware-1.3.ebuild,v 1.6 2012/12/11 17:14:04 axs Exp $

inherit toolchain-funcs

DESCRIPTION="Firmware and config for atmel and atmel_cs wlan drivers included in linux 2.6"
HOMEPAGE="http://www.thekelleys.org.uk/atmel/"
SRC_URI="http://www.thekelleys.org.uk/atmel/${P}.tar.gz"

LICENSE="Atmel"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="pcmcia usb"

RDEPEND="|| ( virtual/udev >=sys-apps/hotplug-20040923 )
		!<sys-fs/udev-096
		>=net-wireless/wireless-tools-26-r1
		pcmcia? ( virtual/pcmcia )"

src_compile() {
	tc-export CC
	emake atmel_fwl || die
}

src_install() {
	insinto /lib/firmware
	doins images/*.bin || die
	if use usb; then
		doins images.usb/*.bin || die
	fi

	if use pcmcia; then
		insinto /etc/pcmcia
		doins atmel.conf || die
	fi

	dosbin atmel_fwl atmel_fwl.pl || die
	doman atmel_fwl.8
	dodoc README VERSION
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
