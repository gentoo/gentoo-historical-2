# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/gibbs/gibbs-1995.9.ebuild,v 1.3 2009/09/30 14:40:39 weaver Exp $

DESCRIPTION="The Gibbs Motif Sampler identifies motifs, conserved regions, in DNA or protein sequences"

HOMEPAGE="http://www.people.fas.harvard.edu/~junliu/index1.html"

SRC_NAME="gibbs9_95"    # 9_95 refers to the september 1995 version
SRC_URI="http://www.fas.harvard.edu/~junliu/Software/${SRC_NAME}.tar"

LICENSE="public-domain"

SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}"/${SRC_NAME}/code

src_compile() {
	LIBS="-lm" make -e || die
}

src_install() {
	cd "${WORKDIR}"/${SRC_NAME}
	dobin gibbs purge scan
	dobin "${FILESDIR}"/gibbs-demo

	dodoc README

	insinto /usr/share/${PN}
	doins demo.out
	insinto /usr/share/${PN}/examples
	doins examples/*
}

pkg_postinst() {
	einfo 'Testcase: To ensure the gibbs sampler works correctly,'
	einfo 'run "gibbs-demo > mydemo.out" and compare "mydemo.out"'
	einfo 'with "/usr/share/gibbs/demo.out" using diff. The files'
	einfo 'should differ only by their timing statistics and the'
	einfo 'paths of the example files.'
}
