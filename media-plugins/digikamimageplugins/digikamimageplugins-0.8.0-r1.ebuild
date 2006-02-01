# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/digikamimageplugins/digikamimageplugins-0.8.0-r1.ebuild,v 1.2 2006/02/01 11:55:25 cryos Exp $

inherit kde

P_DOC="${PN}-doc-${PV}"
MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="DigikamImagePlugins are a collection of plugins for digiKam Image Editor."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/digikam/${MY_P}.tar.bz2
	mirror://sourceforge/digikam/${P_DOC}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="|| ( ~media-gfx/digikam-0.8.0 ~media-gfx/digikam-0.8.1 )
	>=media-gfx/imagemagick-5.5.4
	>=media-video/mjpegtools-1.6.0
	virtual/opengl"

need-kde 3.2

src_compile(){
	kde_src_compile
	cd ${WORKDIR}/${P_DOC}
	kde_src_compile
}

src_install(){
	kde_src_install
	cd ${WORKDIR}/${P_DOC}
	kde_src_install
}
