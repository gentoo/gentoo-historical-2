# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/kipi-plugins/kipi-plugins-0.1.0_rc2.ebuild,v 1.1 2006/05/20 16:35:46 carlo Exp $

inherit kde

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Plugins for the KDE Image Plugin Interface (libkipi)."
HOMEPAGE="http://extragear.kde.org/apps/kipi/"
SRC_URI="mirror://sourceforge/kipi/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="opengl gphoto2"

DEPEND="media-libs/libkexif
	media-libs/libkipi
	gphoto2? ( >=media-libs/libgphoto2-2.1.4 )
	>=media-libs/imlib2-1.1.0
	>=media-gfx/imagemagick-5.5.4
	>=media-video/mjpegtools-1.6.0
	opengl? ( virtual/opengl )
	media-libs/tiff"
RDEPEND="${DEPEND}
	media-gfx/dcraw"
need-kde 3.1

pkg_setup(){
	slot_rebuild "media-libs/libkipi media-libs/libkexif" && die
}

src_compile() {
	myconf="$(use_with opengl) $(use_with gphoto2)"
	kde_src_compile all
}
