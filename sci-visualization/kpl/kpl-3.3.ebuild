# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/kpl/kpl-3.3.ebuild,v 1.5 2007/03/13 14:04:14 armin76 Exp $

inherit kde

DESCRIPTION="KDE tool for plotting data sets and functions in 2D and 3D."
HOMEPAGE="http://frsl06.physik.uni-freiburg.de/privat/stille/kpl/"
SRC_URI="http://frsl06.physik.uni-freiburg.de/privat/stille/kpl/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

need-kde 3.2

PATCHES="${FILESDIR}/${PN}-3.2-arts-configure.patch"
