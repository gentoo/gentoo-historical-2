# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/kipi-plugins/kipi-plugins-0.1.4.ebuild,v 1.2 2007/07/17 12:01:47 keytoaster Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit kde

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Plugins for the KDE Image Plugin Interface (libkipi)."
HOMEPAGE="http://www.kipi-plugins.org/"
SRC_URI="mirror://sourceforge/kipi/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="opengl gphoto2"

DEPEND=">=media-libs/libkipi-0.1.5
	>=media-libs/libkexiv2-0.1.5
	>=media-libs/libkdcraw-0.1.1
	gphoto2? ( >=media-libs/libgphoto2-2.3.1 )
	>=media-libs/imlib2-1.1.0
	>=media-gfx/imagemagick-6.2.4
	>=media-video/mjpegtools-1.6.0
	opengl? ( virtual/opengl )
	>=media-libs/tiff-3.5
	>=dev-libs/libxslt-1.1"

need-kde 3.5

pkg_setup(){
	slot_rebuild "media-libs/libkipi media-libs/libkexif" && die
	if ! built_with_use media-libs/imlib2 X ; then
		eerror "X support is required in media-libs/imlib2 in order to be able"
		eerror "to compile media-plugins/kipi-plugins. Please, re-emerge"
		eerror "media-libs/imlib2 with the 'X' USE flag enabled."
		die
	fi
}

src_compile() {
	myconf="$(use_with opengl) $(use_with gphoto2)"
	kde_src_compile all
}
