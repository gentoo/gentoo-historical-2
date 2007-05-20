# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/ktechlab/ktechlab-0.3.6.ebuild,v 1.1 2007/05/20 14:51:37 calchan Exp $

inherit kde

DESCRIPTION="KTechlab is a development and simulation environment for microcontrollers and electronic circuits"
HOMEPAGE="http://sourceforge.net/projects/ktechlab/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

IUSE=""
SLOT="0"

DEPEND=">=dev-embedded/gpsim-0.21.11"

need-kde 3.2

UNSERMAKE=""

S="${WORKDIR}/${PN}-0.3"

PATCHES="${FILESDIR}/${PN}-0.3-gcc-4.1.patch"
