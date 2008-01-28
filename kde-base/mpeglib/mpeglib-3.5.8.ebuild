# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/mpeglib/mpeglib-3.5.8.ebuild,v 1.2 2008/01/28 22:33:01 philantrop Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE mpeg library"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND="media-sound/cdparanoia
	x11-libs/libXext
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	media-libs/libvorbis"

DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/videoproto"

src_compile() {
	myconf="--with-cdparanoia --enable-cdparanoia"
	kde-meta_src_compile
}
