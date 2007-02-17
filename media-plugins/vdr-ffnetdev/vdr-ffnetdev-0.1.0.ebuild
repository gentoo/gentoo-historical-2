# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-ffnetdev/vdr-ffnetdev-0.1.0.ebuild,v 1.6 2007/02/17 01:18:30 zzam Exp $

inherit vdr-plugin eutils

DESCRIPTION="VDR Plugin: Output device which offers OSD via VNC and Video as raw mpeg over network"
HOMEPAGE="http://ffnetdev.berlios.de"
SRC_URI="http://download.berlios.de/ffnetdev/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

S=${WORKDIR}/${P}

DEPEND=">=media-video/vdr-1.3.7"

src_unpack() {
	vdr-plugin_src_unpack

	if grep -q "virtual cString Active" /usr/include/vdr/plugin.h; then
	  epatch ${FILESDIR}/${P}-bigpatch-headers.diff
	fi
}

