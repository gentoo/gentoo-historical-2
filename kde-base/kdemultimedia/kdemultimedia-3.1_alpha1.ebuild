# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia/kdemultimedia-3.1_alpha1.ebuild,v 1.4 2002/07/13 09:14:57 danarmak Exp $
inherit kde-dist flag-o-matic

DESCRIPTION="${DESCRIPTION}Multimedia"

newdepend ">=sys-libs/ncurses-5.2
	>=media-sound/cdparanoia-3.9.8
	>=media-libs/libvorbis-1.0_beta4
	>=media-video/xanim-2.80.1
	nas? ( >=media-libs/nas-1.4.1 )
	esd? ( >=media-sound/esound-0.2.22 )
	motif? ( >=x11-libs/openmotif-2.1.30 )
	slang? ( >=sys-libs/slang-1.4.4 )
	app-cdr/cdrtools
	>=app-cdr/cdrdao-1.1.5
	>=media-sound/mpg123-0.59r
	tcltk? ( >=dev-lang/tk-8.0.5-r2 )
	>=dev-libs/glib-1.3.3
	>=media-libs/xine-lib-0.9.9
	oggvorbis? ( media-libs/libvorbis )"
	#gtk? ( =x11-libs/gtk+-1.2* )
#	alsa? ( >=media-libs/alsa-lib-0.5.9 )"

replace-flags "-O3" "-O2"

myaudio="--enable-audio=oss"
myinterface="--enable-interface=xaw,ncurses"
myconf="$myconf --enable-xaw --enable-ncurses"
myconf="$myconf --with-xine-prefix=/usr"

#use alsa	&& myconf="$myconf --with-alsa --with-arts-alsa" && myaudio="$myaudio,alsa" ||
myconf="$myconf --without-alsa --disable-alsa"
use nas		&& myaudio="$myaudio,nas --with-nas-library=/usr/X11R6/lib/libaudio.so --with-nas-includes=/usr/X11R6/include" || myconf="$myconf --disable-nas"
use esd		&& myaudio="$myaudio,esd"			|| myconf="$myconf --disable-esd"
use motif	&& myinterface="$myinterface,motif" && myconf="$myconf --enable-motif"
# kmidi/TIMIDITY miscompiles with gtk
#use gtk		&& myinterface="$myinterface,gtk"   && myconf="$myconf --enable-gtk"
use slang	&& myinterface="$myinterface,slang" && myconf="$myconf --enable-slang"
use tcltk	&& myinterface="$myinterface,tcltk" && myconf="$myconf --enable-tcltk"
use oggvorbis	&& myconf="$myconf --with-vorbis=/usr"		|| myconf="$myconf --without-vorbis"

myconf="$myconf $myaudio $myinterface"

src_unpack() {
    
    base_src_unpack
    cd ${S}
    patch -p0 < ${FILESDIR}/${P}-gentoo-timidity.diff || die
    
}

pkg_postinst() {

    if [ -n "`use alsa`" ]; then
	einfo "WARNING: alsa support has been removed becuase of a bug in kdemm sources.
For further information see bug #2324 on bugs.gentoo.org and bug #39574 on bugs.kde.org.
Meanwhile, you can use the alsa oss emulation."
    fi
    return 0

}
