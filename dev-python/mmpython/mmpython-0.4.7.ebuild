# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mmpython/mmpython-0.4.7.ebuild,v 1.2 2005/01/29 17:59:33 iggy Exp $

inherit distutils

DESCRIPTION="Media metadata retrieval framework for Python."
HOMEPAGE="http://sourceforge.net/projects/mmpython/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="dvd"

DEPEND="${DEPEND}
	dvd? ( >=media-libs/libdvdread-0.9.3  >=media-video/lsdvd-0.10 )"
