# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/fuse/fuse-0.6.1.1.ebuild,v 1.3 2003/11/21 06:40:54 mr_bones_ Exp $

DESCRIPTION="Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://www.srcf.ucam.org/~pak21/spectrum/fuse.html"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="X svga libdsk gtk gtk2 sdl svga fbcon gnome"

# This build is heavily use dependent. USE="svga" will build the svga
# version of fuse, otherwise X will be used. Libdsk must be specified
# in order to take advantage of +3 emulation.
DEPEND="dev-lang/perl
	xml2? ( dev-libs/libxml2 )
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )
	>=app-emulation/libspectrum-0.1.0
	|| (
		X? (
			virtual/x11
			|| (
				gtk2? ( =x11-libs/gtk+-2* )
				gtk? ( =x11-libs/gtk+-1* )
			)
		)
		sdl? ( media-libs/libsdl )
		svga? ( media-libs/svgalib )
		fbcon? ( )
		virtual/x11
	)
	gnome? ( =dev-libs/glib-1* )
	libdsk? ( app-emulation/libdsk
		app-emulation/lib765 )"

src_compile() {
	local guiflag
	if [ `use X` ] ; then
		guiflag="--with-x"
	elif [ `use sdl` ] ; then
		guiflag="--without-x --with-sdl"
	elif [ `use svga` ] ; then
		guiflag="--without-x --with-svgalib"
	elif [ `use fbcon` ] ; then
		guiflag="--without-x --with-fb"
	else
		guiflag="--with-x"
	fi
	econf \
		`use_with gnome glib` \
		`use_with gtk` \
		`use_with gtk2` \
		`use_with libdsk plus3-disk` \
		|| die
	emake || die
}

src_install() {
	emake install DESTDIR=${D} || die
	dodoc AUTHORS README THANKS hacking/*.txt
}
