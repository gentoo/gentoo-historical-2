# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/audiofile/audiofile-0.2.6-r1.ebuild,v 1.18 2007/03/19 18:05:14 grobian Exp $

inherit libtool eutils

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="http://www.68k.org/~michael/audiofile/"
SRC_URI="http://www.68k.org/~michael/audiofile/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"/sfcommands
	epatch "${FILESDIR}"/sfconvert-eradicator.patch
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	elibtoolize
}

src_compile() {
	econf --enable-largefile || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ACKNOWLEDGEMENTS AUTHORS ChangeLog README TODO NEWS NOTES
}
