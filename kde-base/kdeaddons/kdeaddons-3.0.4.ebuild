# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons/kdeaddons-3.0.4.ebuild,v 1.7 2003/09/11 01:16:25 msterret Exp $
inherit kde-dist flag-o-matic

IUSE="sdl svga"
DESCRIPTION="KDE $PV: addons - applets, plugins..."
KEYWORDS="x86 ppc alpha"

newdepend "~kde-base/kdebase-${PV}
	~kde-base/kdenetwork-${PV}
	~kde-base/kdemultimedia-${PV}
	~kde-base/arts-1.0.4
	sdl? ( >=media-libs/libsdl-1.2 )
	svga? ( media-libs/svgalib )"

use sdl && myconf="$myconf --with-sdl --with-sdl-prefix=/usr" || myconf="$myconf --without-sdl --disable-sdltest"

# fix bug #7625
if [ "$COMPILER" == "gcc3" ]; then
	if [ -n "`is-flag -march=pentium4`" -o -n "`is-flag -mcpu=pentium4`" ]; then
		append-flags -mno-sse2
	fi
fi
