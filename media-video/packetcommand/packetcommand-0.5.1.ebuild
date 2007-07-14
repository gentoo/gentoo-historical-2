# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/packetcommand/packetcommand-0.5.1.ebuild,v 1.1 2007/07/14 15:38:23 zzam Exp $

inherit linux-mod eutils

DESCRIPTION="A driver for the em84xx dvd disc access."
HOMEPAGE="http://www.htpc-forum.de"
SRC_URI="http://www.htpc-forum.de/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="media-video/em84xx-modules"

CONFIG_CHECK="IDE"

pkg_setup() {
	linux-mod_pkg_setup
	MODULE_NAMES="packetcommand(video:)"
	BUILD_TARGETS="all"
	BUILD_PARAMS="KDIR=\"${KV_DIR}\" V=1"
}

