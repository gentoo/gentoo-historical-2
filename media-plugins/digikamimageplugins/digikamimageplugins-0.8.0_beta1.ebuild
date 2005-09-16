# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/digikamimageplugins/digikamimageplugins-0.8.0_beta1.ebuild,v 1.1 2005/09/16 23:14:53 cryos Exp $

inherit kde

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="DigikamImagePlugins are a collection of plugins for Digikam Image Editor."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/digikam/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="=media-gfx/digikam-${PV}
	>=media-gfx/imagemagick-5.5.4
	>=media-video/mjpegtools-1.6.0
	virtual/opengl"

need-kde 3.2
