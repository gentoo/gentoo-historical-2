# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia/kdemultimedia-3.2.0_beta1.ebuild,v 1.7 2003/11/06 18:40:33 caleb Exp $
inherit kde-dist flag-o-matic

IUSE="nas esd motif slang tcltk oggvorbis gtk alsa gstreamer"
DESCRIPTION="KDE multimedia apps: noatun, kscd, artsbuilder..."
KEYWORDS="~x86"

newdepend ">=sys-libs/ncurses-5.2
	>=media-sound/cdparanoia-3.9.8
	>=media-sound/mpg123-0.59r
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )
	nas? ( >=media-libs/nas-1.4.1 )
	esd? ( >=media-sound/esound-0.2.22 )
	motif? ( virtual/motif )
	slang? ( >=sys-libs/slang-1.4.4 )
	tcltk? ( >=dev-lang/tk-8.0.5-r2 )
	>=dev-libs/glib-1.3.3
	>=media-libs/xine-lib-1_beta10
	gtk? ( =x11-libs/gtk+-1.2* )
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	gstreamer? ( media-libs/gstreamer )
	>=media-libs/id3lib-3.8
	!media-sound/juk"

replace-flags "-O3" "-O2"

myaudio="--enable-audio=oss"
myinterface="--enable-interface=xaw,ncurses"
myconf="$myconf --enable-xaw --enable-ncurses"
myconf="$myconf --with-xine-prefix=/usr"

# make -j2 fails, at least on ppc
use ppc && export MAKEOPTS="$MAKEOPTS -j1"

# alsa 0.9 not supported
use alsa	&& myconf="$myconf --with-alsa --with-arts-alsa" && myaudio="$myaudio,alsa" || myconf="$myconf --without-alsa --disable-alsa"
use nas		&& myaudio="$myaudio,nas --with-nas-library=/usr/X11R6/lib/libaudio.so --with-nas-includes=/usr/X11R6/include" || myconf="$myconf --disable-nas"
use esd		&& myaudio="$myaudio,esd"			|| myconf="$myconf --disable-esd"
use motif	&& myinterface="$myinterface,motif" && myconf="$myconf --enable-motif"
use slang	&& myinterface="$myinterface,slang" && myconf="$myconf --enable-slang"
use tcltk	&& myinterface="$myinterface,tcltk" && myconf="$myconf --enable-tcltk"
use oggvorbis	&& myconf="$myconf --with-vorbis=/usr"		|| myconf="$myconf --without-vorbis"

myconf="$myconf $myaudio $myinterface --with-cdda"

src_unpack() {
	kde_src_unpack
}

src_compile() {
	kde_src_compile
}
