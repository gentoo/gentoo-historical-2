# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/zinf/zinf-2.2.4.ebuild,v 1.4 2003/09/11 01:21:32 msterret Exp $

IUSE="esd X gtk oggvorbis gnome arts"

inherit kde-functions

S=${WORKDIR}/${P}
DESCRIPTION="An extremely full-featured mp3/vorbis/cd player with ALSA support, previously called FreeAmp"
SRC_URI="http://telia.dl.sourceforge.net/sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.zinf.org/"

RDEPEND="=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	sys-libs/zlib
	>=sys-libs/ncurses-5.2
	=media-libs/freetype-1*
	>=media-libs/musicbrainz-1.0.1
	>=media-libs/id3lib-3.8.0
	X? ( virtual/x11 )
	esd? ( media-sound/esound )
	gtk? ( >=media-libs/gdk-pixbuf-0.8 )
	gnome? ( gnome-base/ORBit )
	oggvorbis? ( media-libs/libvorbis )
	arts? ( kde-base/arts )" # doesn't work anymore? see bug #9675
	#alsa? ( media-libs/alsa-lib ) # it only supports alsa 0.5.x, so support disabled

DEPEND="$RDEPEND x86? ( dev-lang/nasm )
	media-libs/id3lib
	dev-lang/perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~alpha"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/zinf-2.2.4-pref.patch
}

src_compile() {
	set-kdedir 3

	local myconf="--disable-alsa --enable-debug --enable-cmdline"
	use esd  || myconf="${myconf} --disable-esd"
	use gnome && myconf="${myconf} --enable-corba"

	if [ -n "`use arts`" ]; then
	    export ARTSCCONFIG="$KDEDIR/bin/artsc-config"
	    myconf="${myconf} --enable-arts"
	else
	    myconf="$myconf --disable-arts"
	fi

	econf ${myconf} || die
	make || die
}

src_install() {
	into /usr ; dobin base/zinf
	exeinto /usr/lib/zinf/plugins  ; doexe plugins/*
	insinto /usr/share/zinf/themes ; doins themes/*

	dodoc AUTHORS COPYING NEWS README
}

