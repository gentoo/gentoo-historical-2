# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/cssed/cssed-0.2.0.ebuild,v 1.3 2004/04/25 15:58:41 dholm Exp $

DESCRIPTION="CSSED a GTK2 application to help create and maintain CSS style sheets for web developing"
HOMEPAGE="http://cssed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="X gnome gtk"
DEPEND=">=x11-libs/gtk+-2
		>=dev-libs/atk-1.4.0
		>=dev-libs/expat-1.95.6-r1
		>=dev-libs/glib-2.2.3
		>=dev-libs/libxml2-2.5.11
		>=dev-libs/openssl-0.9.6k
		>=dev-libs/popt-1.7-r1
		>=gnome-base/ORBit2-2.8.2
		>=gnome-base/gconf-2.4.0.1
		>=gnome-base/gnome-vfs-2.4.0
		>=gnome-base/libbonobo-2.4.0
		>=gnome-base/libbonoboui-2.4.0
		>=gnome-base/libgnomecanvas-2.4.0
		>=gnome-base/libgnomeui-2.4.0.1
		>=media-libs/alsa-lib-0.9.2
		>=media-libs/audiofile-0.2.3-r1
		>=media-libs/fontconfig-2.2.0-r2
		>=media-libs/freetype-2.1.4
		>=media-libs/jpeg-6b-r3
		>=media-libs/libart_lgpl-2.3.16
		>=media-sound/esound-0.2.32
		>=sys-libs/ncurses-5.3-r2
		>=sys-libs/zlib-1.1.4-r2
		x11-base/xfree
		>=x11-libs/gtk+-2.2.4-r1
		>=x11-libs/pango-1.2.1-r1
		>=x11-libs/vte-0.11.10"

S=${WORKDIR}/cssed-0.2.0

src_compile() {
	./autogen.sh --prefix=/usr
	emake || die
}

src_install() {
	einstall || die
}

