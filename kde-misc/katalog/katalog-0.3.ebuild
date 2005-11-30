# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/katalog/katalog-0.3.ebuild,v 1.1.1.1 2005/11/30 09:57:13 chriswhite Exp $

inherit kde

DESCRIPTION="Integrated cataloger for KDE"
SRC_URI="http://salvaste.altervista.org/${P}.tar.gz"
HOMEPAGE="http://salvaste.altervista.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~sparc x86"
IUSE=""

need-kde 3.2
