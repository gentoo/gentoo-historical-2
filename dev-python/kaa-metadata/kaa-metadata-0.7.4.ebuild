# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kaa-metadata/kaa-metadata-0.7.4.ebuild,v 1.1 2008/10/25 14:57:46 rbu Exp $

inherit python eutils distutils

DESCRIPTION="Powerful media metadata parser for media files in Python, successor of MMPython"
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dvd css"

DEPEND=">=dev-python/kaa-base-0.3.0
	dvd? ( media-libs/libdvdread )
	css? ( media-libs/libdvdcss )"
RDEPEND="${DEPEND}
	!dev-python/mmpython"
