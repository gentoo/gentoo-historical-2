# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics/kdegraphics-3.3.0.ebuild,v 1.6 2004/09/02 14:39:33 caleb Exp $

inherit kde-dist eutils

DESCRIPTION="KDE graphics-related apps"

KEYWORDS="~x86 ~amd64 ppc64 ~sparc ppc"
IUSE="gphoto2 imlib opengl scanner tetex"

DEPEND="~kde-base/kdebase-${PV}
	gphoto2? ( media-gfx/gphoto2 )
	scanner? ( media-gfx/sane-backends )
	tetex? ( virtual/tetex )
	dev-libs/fribidi
	opengl? ( virtual/glut virtual/opengl )
	imlib? ( media-libs/imlib )
	virtual/ghostscript
	media-libs/tiff
	x86? ( scanner? sys-libs/libieee1284 )
	!media-gfx/kolourpaint"
RDEPEND="${DEPEND}
	app-text/xpdf"

src_unpack() {
	kde_src_unpack
}

src_compile() {

	use gphoto2	\
		&& myconf="$myconf --with-kamera \
				   --with-gphoto2-includes=/usr/include/gphoto2 \
				   --with-gphoto2-libraries=/usr/lib/gphoto2" \
		|| myconf="$myconf --without-kamera"

	use tetex 	&& myconf="$myconf --with-system-kpathsea --with-tex-datadir=/usr/share"

	use scanner	|| DO_NOT_COMPILE="$DO_NOT_COMPILE kooka libkscan"

	use imlib \
		&& myconf="$myconf --with-imlib --with-imlib-config=/usr/bin" \
		|| myconf="$myconf --without-imlib"

	kde_src_compile
}
