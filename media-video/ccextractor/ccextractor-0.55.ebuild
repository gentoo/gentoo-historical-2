# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ccextractor/ccextractor-0.55.ebuild,v 1.1 2009/09/14 16:19:47 beandog Exp $

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="http://ccextractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/ccextractor/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	cd "${S}"/src
	$(tc-getCXX) -D_FILE_OFFSET_BITS=64 -o ccextractor \
		*.cpp || die "src_compile died"
}

src_install() {
	dobin "${S}/src/ccextractor"
	dodoc "${S}"/docs/*.TXT
}
