# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pccts/pccts-1.33.33.ebuild,v 1.17 2006/07/05 06:49:45 vapier Exp $

inherit eutils

DESCRIPTION="Purdue Compiler Construction Tool Set is an embedded C/C++ parser generator"
HOMEPAGE="http://www.polhode.com/"
SRC_URI="http://www.polhode.com/pccts133mr33.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc-macos ppc64 sh sparc x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PF}-gentoo.diff
}

src_compile() {
	emake COPT="${CFLAGS}" || die "compilation failed"
}

src_install() {
	# main binaries
	dobin bin/{antlr,dlg,genmk,sor} || die

	# .c and .cpp files go into /usr/include/pccts also,
	# because genmk looks for them for being included in output-files
	# (which are c/c++) generated from grammar-files
	# right now i include _everything_ just to make sure
	# it doesn't break pccts-based projects
	#
	# if i dive further into the details of genmk.c
	# it should be possible to put that stuff into /usr/share/pccts
	#
	# the M$ and MAC specific stuff gets _not_ included
	#
	# main includes
	insinto /usr/include/pccts
	doins h/*.{h,c,cpp} || die

	# sorcerer includes
	insinto /usr/include/pccts/sorcerer
	doins sorcerer/h/*.{h,c,cpp} || die

	# sorcerer libraries
	insinto /usr/include/pccts/sorcerer/lib
	doins sorcerer/lib/*.{h,c,cpp} || die

	# documentation
	# leaving out the M$ and MAC stuff
	dodoc CHANGES* KNOWN_PROBLEMS* README RIGHTS history.txt history.ps
	dodoc sorcerer/README sorcerer/UPDATES

	# manual pages
	doman dlg/dlg.1 antlr/antlr.1
}
