# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pvr350/vdr-pvr350-2008.05.30.ebuild,v 1.1 2008/06/02 05:17:33 zzam Exp $
inherit vdr-plugin eutils

IUSE="yaepg"

MY_PV="${PV//./-}"
MY_P="${PN#vdr-}-${MY_PV}"

DESCRIPTION="VDR plugin: use a PVR350 as output device"
HOMEPAGE="http://drseltsam.device.name/vdr/pvr/src/pvr350/"
SRC_URI="http://drseltsam.device.name/vdr/pvr/src/pvr350/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

S="${WORKDIR}/${MY_P}"

DEPEND=">=media-video/vdr-1.4.0
	media-sound/twolame"
RDEPEND="${DEPEND}"

DEPEND="${DEPEND}
	|| ( >=sys-kernel/linux-headers-2.6.22-r2 media-tv/ivtv )"

pkg_setup() {
	vdr-plugin_pkg_setup

	if use yaepg; then
		elog "Checking for patched vdr"
		grep -q fontYaepg /usr/include/vdr/font.h
		eend $? "You need to emerge vdr with use-flag yaepg set!" || die "Unpatched vdr detected!"

		VDRPLUGIN_MAKE_TARGET="all SET_VIDEO_WINDOW=1"
	fi
}

