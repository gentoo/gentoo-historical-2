# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wicd/wicd-1.6.2.2.ebuild,v 1.2 2009/11/08 06:27:47 josejx Exp $

EAPI="2"

inherit distutils

DESCRIPTION="A lightweight wired and wireless network manager for Linux"
HOMEPAGE="http://wicd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ioctl libnotify ncurses +pm-utils"

DEPEND=""
# Maybe virtual/dhcp would work, but there are enough problems with
# net-misc/dhcp that I want net-misc/dhcpcd to be guarenteed to be considered
# first if none are installed.
RDEPEND="
	dev-python/dbus-python
	dev-python/pygtk
	|| (
		net-misc/dhcpcd
		net-misc/dhcp
		net-misc/pump
	)
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	|| (
		sys-apps/net-tools
		sys-apps/ethtool
	)
	|| (
		x11-misc/ktsuss
		x11-libs/gksu
		kde-base/kdesu
	)
	ioctl? ( dev-python/python-iwscan dev-python/python-wpactrl )
	libnotify? ( dev-python/notify-python )
	ncurses? ( >=dev-python/urwid-0.9.8.4 )
	pm-utils? ( >=sys-power/pm-utils-1.1.1 )
	"

src_compile() {
	local myconf
	use libnotify || myconf="${myconf} --no-use-notifications"
	use ncurses || myconf="${myconf} --no-install-ncurses"
	use pm-utils || myconf="${myconf} --no-install-pmutils"
	${python} ./setup.py configure --no-install-docs --resume=/usr/share/wicd/scripts/ --suspend=/usr/share/wicd/scripts/ --verbose ${myconf}
	distutils_src_compile
}

src_install() {
	DOCS="CHANGES NEWS AUTHORS README"
	distutils_src_install
	keepdir /var/lib/wicd/configurations \
		|| die "keepdir failed, critical for this app"
	keepdir /etc/wicd/scripts/{postconnect,disconnect,preconnect} \
		|| die "keepdir failed, critical for this app"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "You may need to restart the dbus service after upgrading wicd."
	echo
	elog "To start wicd at boot, add /etc/init.d/wicd to a runlevel and:"
	elog "- Remove all net.* initscripts (except for net.lo) from all runlevels"
	elog "- Add these scripts to the RC_PLUG_SERVICES line in /etc/conf.d/rc"
	elog "(For example, RC_PLUG_SERVICES=\"!net.eth0 !net.wlan0\")"
	# Maintainer's note: the consolekit use flag short circuits a dbus rule and
	# allows the connection. Else, you need to be in the group.
	if has_version sys-auth/pambase; then
		if ! built_with_use sys-auth/pambase consolekit; then
			ewarn "Wicd-1.6 and newer requires your user to be in the 'users' group. If"
			ewarn "you are not in that group, then modify /etc/dbus-1/system.d/wicd.conf"
		fi
	fi
}
