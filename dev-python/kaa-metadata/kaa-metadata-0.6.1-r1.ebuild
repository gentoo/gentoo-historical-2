# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/kaa-metadata/kaa-metadata-0.6.1-r1.ebuild,v 1.1 2007/07/15 17:55:01 rbu Exp $

inherit python eutils distutils

DESCRIPTION="Powerful media metadata parser for media files (audio, video, images) in Python, successor of MMPython"
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dvd css"

RDEPEND=">=dev-python/kaa-base-0.1.3
	dvd? ( media-libs/libdvdread )
	css? ( media-libs/libdvdcss )
	!dev-python/mmpython"
