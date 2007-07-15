# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lzma/lzma-4.27.ebuild,v 1.4 2007/07/15 05:44:57 mr_bones_ Exp $

inherit toolchain-funcs

DESCRIPTION="LZMA Stream Compressor from the SDK"
HOMEPAGE="http://www.7-zip.org/sdk.html"
SRC_URI="mirror://sourceforge/sevenzip/${PN}427.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~mips ~ppc-macos ~x86"
IUSE="doc"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_compile() {
	cd SRC/7zip/Compress/LZMA_Alone
	emake -f makefile.gcc \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		CXX_C="$(tc-getCC) ${CFLAGS}" \
	|| die "Make failed"
}

src_install() {
	dobin SRC/7zip/Compress/LZMA_Alone/lzma
	if use doc; then
		dodoc *.txt
		dohtml *.html
	fi
}
