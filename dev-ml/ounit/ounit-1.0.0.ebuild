# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ounit/ounit-1.0.0.ebuild,v 1.1 2004/08/18 12:17:33 mattam Exp $

DESCRIPTION="Unit testing framework for OCaml"
HOMEPAGE="http://home.wanadoo.nl/maas/ocaml/"
SRC_URI="http://home.wanadoo.nl/maas/ocaml/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND="dev-lang/ocaml
        dev-ml/findlib"

src_compile() {
	emake all allopt || die "emake failed"
}

src_install() {
	# which directory does the lib go into?
	destdir=`ocamlfind printconf destdir`
	# install
	mkdir -p ${D}${destdir} || die
	make \
		OCAMLFIND_DESTDIR=${D}${destdir} \
		OCAMLFIND_LDCONF=dummy install || die
	# typo
	mv LICENCE LICENSE
	# install documentation
	dodoc README LICENSE changelog
}
