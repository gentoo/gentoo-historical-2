# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-extrecmenu/vdr-extrecmenu-0.12a.ebuild,v 1.2 2006/09/08 09:59:52 zzam Exp $

inherit vdr-plugin eutils

S=${WORKDIR}/${VDRPLUGIN}-${PV}

DESCRIPTION="Video Disk Recorder - Extended recordings menu Plugin"
HOMEPAGE="http://martins-kabuff.de/extrecmenu.html"
SRC_URI="http://martins-kabuff.de/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.7"

src_unpack() {
	vdr-plugin_src_unpack

	if grep -q fskProtection /usr/include/vdr/timers.h; then
		sed -i "s:#WITHPINPLUGIN:WITHPINPLUGIN:" Makefile
	fi
}

