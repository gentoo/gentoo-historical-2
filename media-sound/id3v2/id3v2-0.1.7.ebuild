# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3v2/id3v2-0.1.7.ebuild,v 1.11 2005/04/01 21:12:17 hansmi Exp $

IUSE=""

DESCRIPTION="A command line editor for id3v2 tags."
HOMEPAGE="http://id3v2.sourceforge.net/"
SRC_URI="mirror://sourceforge/id3v2/${P}.tar.gz"

DEPEND="media-libs/id3lib"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_unpack()
{
	unpack "${A}"
	cd "${S}"
	# The tarball came with a compiled binary. ;^)
	make clean
	sed -e "/g++/ s|-g|${CFLAGS}|" < Makefile > Makefile.hacked
	mv Makefile.hacked Makefile
}

src_compile()
{
	emake || die
}

src_install()
{
	dobin id3v2
	doman id3v2.1
	dodoc COPYING INSTALL README
}
