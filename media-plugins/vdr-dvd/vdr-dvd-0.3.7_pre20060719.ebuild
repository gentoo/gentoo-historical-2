# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvd/vdr-dvd-0.3.7_pre20060719.ebuild,v 1.2 2006/10/30 14:21:18 zzam Exp $

inherit vdr-plugin

S="${WORKDIR}/dvd"

DESCRIPTION="Video Disk Recorder DVD-Player PlugIn"
HOMEPAGE="http://sourceforge.net/projects/dvdplugin"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.34
		>=media-libs/libdvdcss-1.2.8
		>=media-libs/libdvdnav-0.1.9
		>=media-libs/libdvdread-0.9.4
		>=media-libs/a52dec-0.7.4
		!media-plugins/vdr-dvd-cvs"

RDEPEND="${DEPEND}"

# DO NOT remove "!media-plugins/vdr-dvd-cvs" from DEPEND !!!
# It will fix a conflict with stored ebuilds in Gentoo.de OVERLAY CVS

PATCHES="${FILESDIR}/dvd-a52drc-pre20060719.diff"

src_unpack() {
vdr-plugin_src_unpack

	# Version number fix
	sed -i "s:0.3.6-b03:0.3.7-Pre:" dvd.h
}
