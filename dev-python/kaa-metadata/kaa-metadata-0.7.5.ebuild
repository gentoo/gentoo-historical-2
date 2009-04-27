# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kaa-metadata/kaa-metadata-0.7.5.ebuild,v 1.2 2009/04/27 21:42:22 patrick Exp $

EAPI="2"

inherit python eutils distutils

DESCRIPTION="Powerful media metadata parser for media files in Python, successor of MMPython"
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dvd css"

DEPEND="dev-lang/python[threads]
	>=dev-python/kaa-base-0.3.0
	dvd? ( media-libs/libdvdread )
	css? ( media-libs/libdvdcss )"
RDEPEND="${DEPEND}
	!dev-python/mmpython"
