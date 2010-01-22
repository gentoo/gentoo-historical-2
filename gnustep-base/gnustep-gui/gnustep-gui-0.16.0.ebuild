# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-gui/gnustep-gui-0.16.0.ebuild,v 1.6 2010/01/22 16:57:45 ssuominen Exp $

EAPI=1
inherit gnustep-base multilib

DESCRIPTION="Library of GUI classes written in Obj-C"
HOMEPAGE="http://www.gnustep.org/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

KEYWORDS="~alpha amd64 ppc sparc x86 ~x86-fbsd"
SLOT="0"
LICENSE="LGPL-2.1"

IUSE="jpeg gif png portaudio cups"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-base-1.18.0
	x11-libs/libXt
	>=media-libs/tiff-3
	jpeg? ( >=media-libs/jpeg-6b:0 )
	gif? ( >=media-libs/giflib-4.1 )
	png? ( >=media-libs/libpng-1.2 )
	!x86-fbsd? ( portaudio? ( =media-libs/portaudio-19* ) )
	cups? ( >=net-print/cups-1.1 )
	media-libs/audiofile
	app-text/aspell"
RDEPEND="${DEPEND}"

src_compile() {
	egnustep_env

	myconf="--with-tiff-include=/usr/include --with-tiff-library=/usr/$(get_libdir)"
	use gif && myconf="$myconf --disable-ungif --enable-libgif"
	myconf="$myconf `use_enable jpeg`"
	myconf="$myconf `use_enable png`"
	myconf="$myconf `use_enable portaudio gsnd`"
	myconf="$myconf `use_enable cups`"

	econf $myconf || die "configure failed"

	egnustep_make || die
}

pkg_postinst() {
	ewarn "The shared library version has changed in this release."
	ewarn "You will need to recompile all Applications/Tools/etc in order"
	ewarn "to use this library. Please run revdep-rebuild to do so"
}
