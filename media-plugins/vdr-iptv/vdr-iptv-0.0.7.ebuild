# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-iptv/vdr-iptv-0.0.7.ebuild,v 1.1 2008/02/19 19:12:35 zzam Exp $

inherit vdr-plugin eutils

DESCRIPTION="VDR plugin: Add a logical device capable of receiving IPTV"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/"
SRC_URI="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.4.7-r7"

pkg_setup() {
	vdr-plugin_pkg_setup

	if ! built_with_use media-video/vdr iptv; then
		eerror "VDR is not built with use-flag iptv."
		eerror "Please enable iptv use-flag and recompile VDR."
		die "VDR is not built with use-flag iptv."
	fi
}

src_unpack() {
	vdr-plugin_src_unpack

	fix_vdr_libsi_include sidscanner.c
}
