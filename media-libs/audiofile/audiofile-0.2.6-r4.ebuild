# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/audiofile/audiofile-0.2.6-r4.ebuild,v 1.8 2009/07/06 21:54:40 jer Exp $

inherit libtool autotools base

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="http://www.68k.org/~michael/audiofile/"
SRC_URI="http://www.68k.org/~michael/audiofile/${P}.tar.gz
	mirror://gentoo/${P}-constantise.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

PATCHES=(
	"${FILESDIR}"/sfconvert-eradicator.patch
	"${FILESDIR}"/${P}-m4.patch
	"${WORKDIR}"/${P}-constantise.patch
	"${FILESDIR}"/${P}-fmod.patch

	### Patch for bug #118600
	"${FILESDIR}"/${PN}-largefile.patch
)

src_unpack() {
	base_src_unpack
	cd "${S}"

	sed -i -e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		"${S}"/test/Makefile.am \
		|| die "unable to disable tests building"

	eautoreconf
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
