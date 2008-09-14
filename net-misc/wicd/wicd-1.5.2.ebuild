# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wicd/wicd-1.5.2.ebuild,v 1.1 2008/09/14 14:56:15 darkside Exp $

inherit distutils

DESCRIPTION="A lightweight wired and wireless network manager for Linux"
HOMEPAGE="http://wicd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/dbus-python
	dev-python/pygtk
	|| (
		net-misc/dhcp
		net-misc/dhcpcd
		net-misc/pump
	)
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	|| (
		sys-apps/ethtool
		sys-apps/net-tools
	)"

src_compile() {
	${python} ./setup.py configure --no-install-init --resume=/usr/share/wicd/scripts/ --suspend=/usr/share/wicd/scripts/ --verbose
	distutils_src_compile
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}/wicd-init.d" wicd || die "newinitd failed"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "You may need to restart the dbus service after upgrading wicd."
	echo
	elog "To start wicd at boot, add /etc/init.d/wicd to a runlevel and:"
	elog "- Remove all net.* initscripts (except for net.lo) from all runlevels"
	elog "- Add these scripts to the RC_PLUG_SERVICES line in /etc/conf.d/rc"
	elog "(For example, RC_PLUG_SERVICES=\"!net.eth0 !net.wlan0\")"
}
