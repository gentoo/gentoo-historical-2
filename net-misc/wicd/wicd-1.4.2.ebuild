# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wicd/wicd-1.4.2.ebuild,v 1.1 2008/07/31 18:08:54 darkside Exp $

MY_P="${PN}_${PV}-src"
DESCRIPTION="A lightweight wired and wireless network manager for Linux"
HOMEPAGE="http://wicd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/dbus-python
	dev-python/pygtk
	net-misc/dhcp
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	sys-apps/ethtool"

src_install() {
	mv "${WORKDIR}"/* "${D}" || die "Copy failed"
	newinitd "${FILESDIR}/${P}-init.d wicd"
}

pkg_postinst() {
	elog "Make sure dbus is in the same runlevel"
	elog "as the wicd initscript"
	elog
	elog "Start the WICD GUI using:"
	elog "    /opt/wicd/gui.py"
	elog
	elog "Display the tray icon by running:"
	elog "    /opt/wicd/tray.py"
}
