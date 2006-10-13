# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knemo/knemo-0.4.5.ebuild,v 1.2 2006/10/13 22:53:16 deathwing00 Exp $

inherit kde eutils

DESCRIPTION="KNemo - the KDE Network Monitor"
SRC_URI="http://www.kde-apps.org/content/files/12956-${P}.tar.bz2"
HOMEPAGE="http://kde-apps.org/content/show.php?content=12956"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="wifi"

RDEPEND="kernel_linux? ( sys-apps/net-tools )
	wifi? ( net-wireless/wireless-tools )"

need-kde 3.4

pkg_postinst() {
	echo
	einfo "KNemo is not an executable but a KDED service. Since version 0.4.5"
	einfo "KNemo has to be started using KDE Control Center/Internet & Network/"
	einfo "Network Monitor. Please do no longer use the KDE Service Manager to"
	einfo "start and stop KNemo. This change was necessary to keep KNemo from"
	einfo "starting	automatically for every user in a multiuser environment."
	echo
}
