# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons/kdeaddons-3.1.3.ebuild,v 1.8 2003/09/17 01:35:46 weeve Exp $
inherit kde-dist flag-o-matic

IUSE="sdl svga xmms"
DESCRIPTION="KDE addon modules: plugins for konqueror, noatun etc"
KEYWORDS="x86 ~ppc sparc"

newdepend "=kde-base/kdebase-${PV}*
	~kde-base/kdenetwork-${PV}
	~kde-base/kdemultimedia-${PV}
	~kde-base/arts-${PV//3./1.}
	sdl? ( >=media-libs/libsdl-1.2 )
	svga? ( media-libs/svgalib )
	xmms? ( media-sound/xmms )"

use sdl && myconf="$myconf --with-sdl --with-sdl-prefix=/usr" || myconf="$myconf --without-sdl --disable-sdltest"

use xmms || export ac_cv_have_xmms=no

# fix bug #7625
if [ "$COMPILER" == "gcc3" ]; then
	if [ -n "`is-flag -march=pentium4`" -o -n "`is-flag -mcpu=pentium4`" ]; then
		append-flags -mno-sse2
	fi
fi

# enable building of konqueror carsh recovery plugin. it was disabled accidentally
# in the orig kde 3.1 release and was reenabled soon after in cvs head
PATCHES="$FILESDIR/$P-enable-crashes.diff"

need-automake 1.7
need-autoconf 2.5

src_compile() {
	AMVERSION="`automake --version | head -1 | cut -d " " -f4`"
	if [ "$AMVERSION" != "1.7.2" ]; then
		rm -f configure configure.in
	fi

	kde_src_compile configure
	kde_src_compile make
}

