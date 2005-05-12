# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/t-coffee/t-coffee-2.26.ebuild,v 1.2 2005/05/12 00:22:36 ribosome Exp $

inherit toolchain-funcs

DESCRIPTION="A multiple sequence alignment package"
HOMEPAGE="http://igs-server.cnrs-mrs.fr/~cnotred/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://igs-server.cnrs-mrs.fr/~cnotred/Packages/T-COFFEE_distribution_Version_${PV}.tar.gz"
LICENSE="t-coffee"

RESTRICT="nomirror"

SLOT="0"
IUSE=""
KEYWORDS="x86"

DEPEND="sci-biology/clustalw"

TCDIR="${WORKDIR}/T-COFFEE_distribution_Version_${PV}"
S=${TCDIR}/t_coffee_source

src_unpack(){
	unpack ${A}
	cd ${S}
	sed -i -e "s/CC	= cc/CC	= $(tc-getCC) ${CFLAGS}/" makefile || die || die
	cd ${TCDIR}/bin
	sed -i -e 's%chdir "./example/test";%chdir "../example/test";%' test.pl || die

}

src_compile() {
	make all || die
}

src_install() {
	cd ${TCDIR}/bin
	dobin t_coffee
	insinto /usr/share/${PN}/lib
	doins ${TCDIR}/html

	dodoc ${TCDIR}/doc/README4T-COFFEE
	insinto /usr/share/doc/${PF}
	doins ${TCDIR}/doc/t_coffee{_doc.{doc,pdf},.pdf}

	insinto /usr/share/${PN}/example/seq
	doins ${TCDIR}/example/seq/*
	insinto /usr/share/${PN}/example/test
	doins ${TCDIR}/example/test/*.{aln,pep}
}

src_test() {
	cd ${TCDIR}/bin
	./test.pl || die
}
