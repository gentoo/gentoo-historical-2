# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-submenu/vdr-submenu-0.0.2.ebuild,v 1.4 2007/01/05 16:57:13 hd_brummy Exp $

inherit vdr-plugin

IUSE=""
SLOT="0"

DESCRIPTION="vdr Plugin: DVB Frontend Status Monitor (signal strengt/noise)"
HOMEPAGE="http://www.freewebs.com/sadhome"
SRC_URI="http://www.freewebs.com/sadhome/Plugin/Submenu/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 x86"

DEPEND=">=media-video/vdr-1.3.20"

PATCHES="${FILESDIR}/${P}-asprintf.patch"

pkg_setup() {
	vdr-plugin_pkg_setup

	local header=/usr/include/vdr/submenu.h
	if [[ -e ${header} ]] && grep -q "class cSubMenuItemInfo" ${header} 2>/dev/null; then
		einfo "Patched vdr found"
	else
		elog "Unpatched vdr found"
		echo
		ewarn "You have to reemerge vdr with USE=submenu set"
		echo
		die "need to have patched vdr"
	fi
}
