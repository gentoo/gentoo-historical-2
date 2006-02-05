# Copyright 2003-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-decruft/vdr-decruft-0.0.4.ebuild,v 1.1 2006/02/05 15:53:02 zzam Exp $

IUSE=""
inherit vdr-plugin eutils

DESCRIPTION="Video Disk Recorder DeCruft Plugin - Clean unwanted entries from channels.conf"
HOMEPAGE="http://www.rst38.org.uk/vdr/decruft/"
SRC_URI="http://www.rst38.org.uk/vdr/decruft/${P}.tgz"
KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.3.21-r2"

pkg_setup() {
	vdr-plugin_pkg_setup
	grep -q SetGroupSep ${VDR_INCLUDE_DIR}/vdr/channels.h || die "Unpatched vdr detected!"
}

src_install() {
	vdr-plugin_src_install
	insinto /etc/vdr/plugins
	doins examples/decruft.conf
}

