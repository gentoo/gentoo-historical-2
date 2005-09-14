# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3v2/id3v2-0.1.11.ebuild,v 1.6 2005/09/14 07:30:03 agriffis Exp $

IUSE=""

inherit eutils

DESCRIPTION="A command line editor for id3v2 tags."
HOMEPAGE="http://id3v2.sourceforge.net/"
SRC_URI="mirror://sourceforge/id3v2/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ppc ~ppc64 sparc x86"

DEPEND="media-libs/id3lib"

src_unpack() {
	unpack ${A} && cd ${S} || die "unpack failed"

	# The tarball came with a compiled binary. ;^)
	make clean

	# Use our own CXXFLAGS
	sed -i -e "/g++/ s|-g|${CXXFLAGS}|" Makefile || die "sed failed"

	# Fix segfault on alpha (and probably other architectures)
	epatch ${FILESDIR}/${P}-alpha.patch
}

src_compile() {
	emake || die
}

src_install() {
	dobin id3v2
	doman id3v2.1
	dodoc README
}
