# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pin/vdr-pin-0.0.16.ebuild,v 1.1 2006/05/05 22:38:03 hd_brummy Exp $

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder pin PlugIn"
HOMEPAGE="http://www.jwendel.de"
SRC_URI="http://www.jwendel.de/vdr/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.45-r1"

pkg_setup() {
	vdr-plugin_pkg_setup

	if grep -q fskProtection /usr/include/vdr/timers.h; then
		einfo "Patched vdr found"
	else
		echo
		eerror "Patched VDR needed"
		echo
		einfo "reemerge VDR with USE=\"child-protection\" or USE=\"bigpatch\"" && \
		die "unpack failed, patched VDR needed"
	fi
}

src_install() {
	vdr-plugin_src_install

	dobin ${S}/fskcheck

	into /usr/share/vdr/pin
	dobin ${S}/scripts/*.sh

	insinto /etc/vdr/reccmds
	newins ${FILESDIR}/reccmds.pin.conf-0.0.16 reccmds.pin.conf
}

