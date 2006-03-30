# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-rotor/vdr-rotor-0.1.4.ebuild,v 1.2 2006/03/30 11:10:50 zzam Exp $

inherit vdr-plugin

IUSE=""
SLOT="0"

DESCRIPTION="VDR Plugin: Add support for dishes with rotation control engine"
HOMEPAGE="http://home.vrweb.de/~bergwinkl.thomas/"
SRC_URI="mirror://gentoo/${P}.tgz"
LICENSE="GPL-2"

KEYWORDS="~x86"

DEPEND=">=media-video/vdr-1.3.44"

pkg_setup() {
	vdr-plugin_pkg_setup

	einfo "Checking for patched vdr"
	if ! grep -q SendDiseqcCmd ${VDR_INCLUDE_DIR}/vdr/device.h; then
		ewarn "You need to emerge vdr with use-flag rotor set!"
		die "Unpatched vdr detected!"
	fi
}

src_unpack() {
	vdr-plugin_src_unpack

	sed -i ${S}/filter.c \
		-e "s:libsi/:vdr/libsi/:"
}

