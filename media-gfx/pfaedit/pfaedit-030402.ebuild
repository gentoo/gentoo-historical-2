# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pfaedit/pfaedit-030402.ebuild,v 1.5 2003/09/06 23:56:39 msterret Exp $

inherit flag-o-matic

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="http://pfaedit.sourceforge.net/"
SRC_URI="http://pfaedit.sourceforge.net/pfaedit_full-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE="png gif jpeg tiff truetype X"

DEPEND="png? ( >=media-libs/libpng-1.2.4 )
	gif? ( >=media-libs/libungif-4.1.0-r1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.5.7-r1 )
	truetype? ( >=media-libs/freetype-2.1.2 )"

S="${WORKDIR}/${PN}"

src_compile() {
	local myconf=""
	use X || myconf="--without-x"

	filter-mfpmath "sse" "387"

	econf ${myconf} --without-freetype-src
	make || die
}

src_install() {
	# make install fails if this directory doesn't exist
	dodir /usr/lib
	einstall
	dodoc AUTHORS COPYING LICENSE README
}
