# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-sgml-dtd/docbook-sgml-dtd-4.0-r1.ebuild,v 1.11 2004/09/22 00:24:57 vapier Exp $

inherit sgml-catalog

MY_P="docbk40"
DESCRIPTION="Docbook SGML DTD 4.0"
HOMEPAGE="http://www.oasis-open.org/docbook/sgml/${PV}/index.html"
SRC_URI="http://www.oasis-open.org/docbook/sgml/${PV}/${MY_P}.zip"

LICENSE="X11"
SLOT="4.0"
KEYWORDS="alpha arm amd64 hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=app-arch/unzip-5.41"
RDEPEND="app-text/sgml-common"

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
