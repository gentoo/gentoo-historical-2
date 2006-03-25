# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/camera/camera-0.8.ebuild,v 1.3 2006/03/25 16:41:47 grobian Exp $

inherit gnustep

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="A simple tool to download photos from a digital camera."
HOMEPAGE="http://home.gna.org/gsimageapps/"
SRC_URI="http://download.gna.org/gsimageapps/${P/c/C}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/camerakit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/camerakit"

egnustep_install_domain "System"
