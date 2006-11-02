# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-premiereepg/vdr-premiereepg-0.0.7.ebuild,v 1.1 2006/11/02 09:21:10 zzam Exp $

inherit vdr-plugin eutils

DESCRIPTION="VDR Plugin: The plugin parses the extended EPG data which is send by Premiere on their portal channels"
HOMEPAGE="http://www.muempf.de/index.html"
SRC_URI="http://www.muempf.de/down/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# This plugin uses the libsi-code fixed in v1.4.0-3
DEPEND=">=media-video/vdr-1.4.1"
RDEPEND="${DEPEND}"

src_unpack() {
	vdr-plugin_src_unpack

	cd ${S}
	fix_vdr_libsi_include premiereepg.c
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	ewarn "You should delete your existing /var/vdr/video/epg.data,"
	ewarn "as the Handling of event-IDs has been changed in this release."
}

