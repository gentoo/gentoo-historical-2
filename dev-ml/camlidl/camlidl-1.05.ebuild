# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlidl/camlidl-1.05.ebuild,v 1.1 2004/09/25 20:15:43 mattam Exp $

DESCRIPTION="CamlIDL is a stub code generator for using C/C++ libraries from O'Caml"
HOMEPAGE="http://caml.inria.fr/camlidl/"
SRC_URI="http://caml.inria.fr/distrib/bazar-ocaml/${P}.tar.gz"
LICENSE="QPL-1.0 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
DEPEND=">=dev-lang/ocaml-3.07"

src_compile() {
	# Use the UNIX makefile
	libdir=`ocamlc -where`
	sed -i -e "s|OCAMLLIB=.*|OCAMLLIB=${libdir}|" config/Makefile.unix
	sed -i -e "s|BINDIR=.*|BINDIR=/usr/bin|" config/Makefile.unix
	ln -s Makefile.unix config/Makefile

	# Make
	emake -j1 || die
}

src_test() {
	einfo "Running tests..."
	cd tests
	( make CCPP=g++ && einfo "Tests finished successfully" ) || die "Tests failed"
}

src_install() {
	libdir=`ocamlc -where`
	dodir ${libdir}/caml
	dodir /usr/bin
	# Install
	emake BINDIR=${D}/usr/bin OCAMLLIB=${D}${libdir} install || die

	# Documentation
	dodoc README Changes
}
