# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kid3/kid3-0.4.ebuild,v 1.4 2004/07/03 21:39:10 carlo Exp $

inherit kde

DESCRIPTION="A simple id3 tag editor for QT/KDE with automatic string replacements, case conversion etc."
HOMEPAGE="http://kid3.sourceforge.net/"
SRC_URI="mirror://sourceforge/kid3/${P}.tar.gz"

SLOT="0"
IUSE=""

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=media-libs/id3lib-3.8.3"
need-kde 3.1
