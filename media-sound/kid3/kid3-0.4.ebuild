# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kid3/kid3-0.4.ebuild,v 1.9 2004/12/19 05:00:32 eradicator Exp $

IUSE="arts"

inherit kde eutils

DESCRIPTION="A simple id3 tag editor for QT/KDE with automatic string replacements, case conversion etc."
HOMEPAGE="http://kid3.sourceforge.net/"
SRC_URI="mirror://sourceforge/kid3/${P}.tar.gz"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc sparc amd64"

DEPEND=">=media-libs/id3lib-3.8.3"
need-kde 3.1

src_unpack() {
	kde_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${P}-gcc34.patch
	use arts || epatch ${FILESDIR}/${P}-configure.patch
}
