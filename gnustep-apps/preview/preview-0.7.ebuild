# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/preview/preview-0.7.ebuild,v 1.1 2004/10/13 01:29:27 fafhrd Exp $


inherit gnustep

S=${WORKDIR}/${PN/p/P}

DESCRIPTION="Simple image viewer."
HOMEPAGE="http://home.gna.org/gsimageapps/"
SRC_URI="http://download.gna.org/gsimageapps/${P/p/P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

