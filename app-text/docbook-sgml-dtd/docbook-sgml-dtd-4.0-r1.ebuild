# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-sgml-dtd/docbook-sgml-dtd-4.0-r1.ebuild,v 1.3 2003/02/13 09:34:43 vapier Exp $

inherit sgml-catalog

MY_P="docbk40"
S=${WORKDIR}/${P}
DESCRIPTION="Docbook SGML DTD 4.0"
SRC_URI="http://www.oasis-open.org/docbook/sgml/${PV}/${MY_P}.zip"

HOMEPAGE="http://www.oasis-open.org/docbook/sgml/${PV}/index.html"
LICENSE="X11"

DEPEND=">=app-arch/unzip-5.41"
RDEPEND="app-text/sgml-common"

SLOT="4.0"

KEYWORDS="x86 ppc sparc alpha hppa"
src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
	cp ${FILESDIR}/${P}.Makefile Makefile
	patch -b docbook.cat ${FILESDIR}/${P}-catalog.diff || die
}

sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/usr/share/sgml/docbook/sgml-dtd-${PV}/catalog"
sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/etc/sgml/sgml-docbook.cat"

src_install () {

	make DESTDIR=${D}/usr/share/sgml/docbook/sgml-dtd-${PV} install || die
	dodoc *.txt
}
