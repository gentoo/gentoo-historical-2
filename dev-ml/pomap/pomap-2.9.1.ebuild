# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pomap/pomap-2.9.1.ebuild,v 1.3 2004/03/13 19:51:28 mr_bones_ Exp $

DESCRIPTION="Partially Ordered Map ADT for O'Caml"
HOMEPAGE="http://www.ai.univie.ac.at/~markus/home/ocaml_sources.html"
LICENSE="LGPL-2.1"
DEPEND=">=dev-lang/ocaml-3.06
	>=dev-ml/findlib-0.8"
SRC_URI="http://www.oefai.at/~markus/ocaml_sources/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_compile() {
	emake all || die
}

src_install () {
	# which directory does the lib go into?
	destdir=`ocamlfind printconf destdir`

	# install
	mkdir -p ${D}${destdir} || die
	make	OCAMLFIND_DESTDIR=${D}${destdir} \
		OCAMLFIND_LDCONF=dummy install || die

	# install documentation
	dodoc LICENSE README VERSION Changes

	#install examples
	mv ${S}/examples/ ${D}/usr/share/doc/${PF}/
}
