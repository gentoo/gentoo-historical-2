# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-vompserver/vdr-vompserver-0.2.6.ebuild,v 1.1 2007/02/17 18:58:17 hd_brummy Exp $

inherit vdr-plugin

DESCRIPTION="VDR Plugin: server part for MediaMVP device"
HOMEPAGE="http://www.loggytronic.com/vomp.php"
SRC_URI="http://www.loggytronic.com/dl/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

PATCHES="${FILESDIR}/${P}-gentoo.diff"

src_install() {
	vdr-plugin_src_install

	dodoc README HISTORY COPYING

	insinto /etc/vdr/plugins/vomp
	newins vomp.conf.sample vomp.conf
	newins vomp-00-00-00-00-00-00.conf.sample vomp-00-00-00-00-00-00.conf
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	echo
	elog "Have a look to the VOMP sample files in /etc/vdr/plugins."
	echo
	elog "You have to download the dongle file (i.e. firmware) and adapt"
	elog "the vomp configuration files accordingly."
	echo

	elog "Please edit up from version ${PN}-0.2.6"
	elog "all config files in /etc/vdr/plugins/vomp/"
}

