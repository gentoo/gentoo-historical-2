# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-xml-dtd/docbook-xml-dtd-4.3.ebuild,v 1.4 2004/08/19 20:54:09 gustavoz Exp $

MY_P=${P/-dtd/}

DESCRIPTION="Docbook DTD for XML"
HOMEPAGE="http://www.docbook.org"
SRC_URI="http://www.docbook.org/xml/${PV}/${MY_P}.zip"
LICENSE="X11"

SLOT="4.3"
KEYWORDS="x86 ~ppc sparc ~mips alpha amd64 ia64"
IUSE=""

DEPEND=">=app-arch/unzip-5.41
	>=dev-libs/libxml2-2.4
	>=app-text/docbook-xsl-stylesheets-1.65
	>=app-text/build-docbook-catalog-1.2"

src_unpack() {

	mkdir ${S}
	cd ${S}
	unpack ${A}

}

src_install() {

	keepdir /etc/xml

	insinto /usr/share/sgml/docbook/xml-dtd-${PV}
	doins *.dtd *.mod
	doins docbook.cat
	insinto /usr/share/sgml/docbook/xml-dtd-${PV}/ent
	doins ent/*.ent

	dodoc ChangeLog README

}

pkg_postinst() {
	build-docbook-catalog
}

pkg_postrm() {
	build-docbook-catalog
}
