# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-0.7.5.ebuild,v 1.2 2002/12/16 01:54:44 hannes Exp $

inherit kde-base
need-kde 3

IUSE=""
DESCRIPTION="K3b, KDE CD Writing Software"
SRC_URI="mirror://sourceforge/k3b/${P}.tar.gz"
HOMEPAGE="http://k3b.sourceforge.net"
LICENSE="GPL-2"
KEYWORDS="x86"

newdepend ">=media-sound/mpg123-0.59
	>=media-sound/cdparanoia-3.9.8
	>=media-libs/id3lib-3.8.0_pre2
	>=media-sound/mad-0.14.2b-r1
	media-video/transcode
	media-libs/libvorbis
	>=kde-base/kdebase-3"
	
RDEPEND="$RDEPEND sys-apps/eject
	>=app-cdr/cdrtools-1.11
	>=app-cdr/cdrdao-1.1.5"

myconf="$myconf --enable-sso"
[ -n "$DEBUG" ] && myconf="$myconf --enable-debugging --enable-profiling" || myconf="$myconf --disable-debugging --disable-profiling"


