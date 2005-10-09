# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-streamdev/vdr-streamdev-0.3.3_pre20050529.ebuild,v 1.1 2005/10/09 12:13:15 zzam Exp $

inherit vdr-plugin eutils

MY_P=${PN}-${PV/*_pre/snapshot-}

DESCRIPTION="Video Disk Recorder Client/Server streaming plugin"
HOMEPAGE="http://www.magoa.net/linux/"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.24"

S=${WORKDIR}/${VDRPLUGIN}

src_unpack() {
	vdr-plugin_src_unpack
	cd ${S}

	# make subdir libdvbmpeg respect CXXFLAGS
	sed -i.original libdvbmpeg/Makefile \
		-e 's:CFLAGS =  -g -Wall -O2:CFLAGS = $(CXXFLAGS) :'

	epatch ${FILESDIR}/${P}-includes.patch
}
