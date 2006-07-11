# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/aquapfont/aquapfont-2.5-r1.ebuild,v 1.13 2006/07/11 11:15:43 agriffis Exp $

inherit font

IUSE=""
MY_P="${PN/font/}${PV/\./_}"

DESCRIPTION="Very pretty Japanese proportional truetype font"
HOMEPAGE="http://aquablue.milkcafe.to/"
SRC_URI="http://aquablue.milkcafe.to/fnt/${MY_P}.lzh"

KEYWORDS="alpha amd64 arm ia64 ppc ppc-macos ppc64 s390 sparc x86"
LICENSE="aquafont"
SLOT=0

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="readme.txt"

DEPEND="app-arch/lha"
RDEPEND=""

src_unpack(){

	lha e ${DISTDIR}/${MY_P}.lzh
}
