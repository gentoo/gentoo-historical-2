# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics/kdegraphics-3.5.0-r2.ebuild,v 1.2 2006/01/22 18:50:09 genone Exp $

inherit kde-dist eutils

DESCRIPTION="KDE graphics-related apps"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="gphoto2 imlib openexr opengl pdf povray scanner tetex"

DEPEND="~kde-base/kdebase-${PV}
	>=media-libs/freetype-2
	media-libs/fontconfig
	gphoto2? ( media-libs/libgphoto2 )
	scanner? ( media-gfx/sane-backends )
	media-libs/libart_lgpl
	media-libs/lcms
	dev-libs/fribidi
	imlib? ( media-libs/imlib )
	virtual/ghostscript
	media-libs/tiff
	openexr? ( >=media-libs/openexr-1.2 )
	povray? ( media-gfx/povray
		  virtual/opengl )
	pdf? ( >=app-text/poppler-0.3.1 )"

RDEPEND="${DEPEND}
	tetex? (
	|| ( >=app-text/tetex-2
	     app-text/ptex
	     app-text/cstetex
	     app-text/dvipdfm ) )"

DEPEND="${DEPEND}
	dev-util/pkgconfig"

PATCHES="${FILESDIR}/post-3.5.0-kdegraphics-CAN-2005-3193.diff ${FILESDIR}/kpdf-3.5.0-splitter-io.patch"

pkg_setup() {
	if ! built_with_use virtual/ghostscript X; then
		eerror "This package requires virtual/ghostscript compiled with X11 support."
		eerror "Please reemerge virtual/ghostscript with USE=\"X\"."
		die "Please reemerge virtual/ghostscript with USE=\"X\"."
	fi
	if use pdf && ! built_with_use app-text/poppler qt; then
		eerror "This package requires app-text/poppler compiled with Qt support."
		eerror "Please reemerge app-text/poppler with USE=\"qt\"."
		die "Please reemerge app-text/poppler with USE=\"qt\"."
	fi
}

src_compile() {
	local myconf="$(use_with openexr) $(use_with pdf poppler)
	              $(use_with gphoto2 kamera)"

	use imlib || export DO_NOT_COMPILE="${DO_NOT_COMPILE} kuickshow"
	use scanner || export DO_NOT_COMPILE="${DO_NOT_COMPILE} kooka libkscan"
	use povray || export DO_NOT_COMPILE="${DO_NOT_COMPILE} kpovmodeler"

	kde_src_compile
}
