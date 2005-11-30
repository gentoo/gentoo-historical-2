# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/vindaloo/vindaloo-0.2.ebuild,v 1.1.1.1 2005/11/30 10:02:20 chriswhite Exp $

inherit gnustep

S=${WORKDIR}/${PN/v/V}

DESCRIPTION="An Application for displaying and navigating in PDF documents."

HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${PN/v/V}/${P/v/V}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/popplerkit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/popplerkit"

egnustep_install_domain "Local"
