# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-xml-dtd/docbook-xml-dtd-4.3-r1.ebuild,v 1.4 2007/07/12 04:37:47 mr_bones_ Exp $

inherit sgml-catalog

MY_P=${P/-dtd/}
DESCRIPTION="Docbook DTD for XML"
HOMEPAGE="http://www.docbook.org/"
SRC_URI="http://www.docbook.org/xml/${PV}/${MY_P}.zip"

LICENSE="X11"
SLOT="4.3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=app-arch/unzip-5.41
	>=dev-libs/libxml2-2.4
	>=app-text/docbook-xsl-stylesheets-1.65
	>=app-text/build-docbook-catalog-1.2"

sgml-catalog_cat_include "/etc/sgml/xml-docbook-${PV}.cat" \
	"/etc/sgml/sgml-docbook.cat"
sgml-catalog_cat_include "/etc/sgml/xml-docbook-${PV}.cat" \
	"/usr/share/sgml/docbook/xml-dtd-${PV}/docbook.cat"

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unpack "${A}"

	# Prepend OVERRIDE directive
	sed -i -e '1i\\OVERRIDE YES' docbook.cat
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
	sgml-catalog_pkg_postinst
}

pkg_postrm() {
	build-docbook-catalog
	sgml-catalog_pkg_postrm
}
