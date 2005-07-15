# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/free-bangla-font/free-bangla-font-0.2.ebuild,v 1.7 2005/07/15 16:56:27 flameeyes Exp $

inherit font

AKAASH_P="Akaash-0.8.5"
ANI_P="Ani"
LIKHAN_P="Likhan-0.5"
MUKTINARROW_P="MuktiNarrow-0.94"

DESCRIPTION="Unicode compliant Open Type Bangla fonts"
HOMEPAGE="http://www.nongnu.org/freebangfont/index.html"
SRC_BASE="http://savannah.nongnu.org/download/freebangfont"
SRC_URI="${SRC_BASE}/${AKAASH_P}.tar.gz
	${SRC_BASE}/${ANI_P}.tar.gz
	${SRC_BASE}/${LIKHAN_P}.tar.gz
	${SRC_BASE}/${MUKTINARROW_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

FONT_SUFFIX="ttf TTF"

S="${WORKDIR}"
FONT_S="${WORKDIR}"

src_install() {

	find . -name '*.[tT][tT][fF]' -exec cp {} . \;

	font_src_install

	docinto ${AKAASH_P%-*}
	dodoc ${AKAASH_P%-*}/[A-Z][A-Z]*
	docinto ${ANI_P}
	dodoc ${ANI_P}/[A-Z][A-Z]*
	docinto ${LIKHAN_P%-*}
	dodoc ${LIKHAN_P}/README
	docinto ${MUKTINARROW_P%-*}
	dodoc ${MUKTINARROW_P/-/}/{Changelog,readme.txt}
}
