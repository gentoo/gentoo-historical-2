# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-kde/qalculate-kde-0.9.0.ebuild,v 1.4 2006/01/11 00:34:17 halcy0n Exp $

myconf="--disable-clntest"

inherit kde

DESCRIPTION="A modern multi-purpose calculator for KDE"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~sparc x86"

DEPEND="=sci-libs/libqalculate-0.9.0*
	kde-base/kdelibs"

DOCS="AUTHORS ChangeLog NEWS README TODO"

need-kde 3.1
