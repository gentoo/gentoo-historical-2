# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kdebluetooth/kdebluetooth-20050000.ebuild,v 1.1 2004/07/31 15:10:39 carlo Exp $

inherit kde

DESCRIPTION="KDE Bluetooth Framework"
HOMEPAGE="http://kde-bluetooth.sourceforge.net/"
SRC_URI="http://www.webalice.it/simone.gotti/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-libs/openobex-1
	>=net-wireless/bluez-libs-2
	>=net-wireless/bluez-sdp-1"
RDEPEND=">=dev-libs/openobex-1
	>=net-wireless/bluez-libs-2
	>=net-wireless/bluez-sdp-1"
need-kde 3

RESTRICT="fetch"

pkg_nofetch() {
	einfo "This package follows upstream version numbering from now."
	einfo "Please execute \"emerge =kdebluetooth-0.0.20040625\" to get"
	einfo "the newest ebuild. This one will be removed in two weeks."
}
