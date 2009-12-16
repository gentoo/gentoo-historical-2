# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-xml-simple-dtd/docbook-xml-simple-dtd-4.1.2.5-r1.ebuild,v 1.1 2009/12/16 10:18:36 flameeyes Exp $

DESCRIPTION="Simplified Docbook DTD for XML"
HOMEPAGE="http://www.oasis-open.org/docbook/xml/simple/4.1.2.5/"
SRC_URI="http://www.nwalsh.com/docbook/simple/${PV}/simple4125.zip"

LICENSE="X11"
SLOT="4.1.2.5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=app-arch/unzip-5.41
	dev-libs/libxml2"
RDEPEND=""

S=${WORKDIR}

xml_catalog_setup() {
	CATALOG="${ROOT}etc/xml/catalog"
	XMLTOOL="${ROOT}usr/bin/xmlcatalog"
	DTDDIR="${ROOT}usr/share/sgml/docbook/${P#docbook-}"

	[ -x "${XMLTOOL}" ] || return 1

	return 0
}

src_install() {
	insinto /usr/share/sgml/docbook/${P#docbook-}
	doins *.dtd *.mod *.css

	newins "${FILESDIR}"/${P}.catalog catalog
}

pkg_postinst() {
	xml_catalog_setup || return

	einfo "Installing docbook-simple-dtd-4.1.2.5 in the global XML catalog"

	$XMLTOOL --noout --add 'public' \
		'-//OASIS//DTD Simplified DocBook XML V4.1.2.5//EN' \
		${DTDDIR}/sdocbook.dtd $CATALOG
	$XMLTOOL --noout --add 'rewriteSystem' \
		'http://www.oasis-open.org/docbook/xml/simple/4.1.2.5' \
		${DTDDIR} $CATALOG
	$XMLTOOL --noout --add 'rewriteURI' \
		'http://www.oasis-open.org/docbook/xml/simple/4.1.2.5' \
		${DTDDIR} $CATALOG
}

pkg_postrm() {
	xml_catalog_setup || return

	if [ -d "$DTDDIR" ]; then
		einfo "The simple-dtd-4.1.2.5 data directory still exists."
		einfo "No entries will be removed from the XML catalog."
		return
	fi

	einfo "Removing docbook-simple-dtd-4.1.2.5 from the global XML catalog"

	$XMLTOOL --noout --del \
		'-//OASIS//DTD Simplified DocBook XML V4.1.2.5//EN' $CATALOG
	$XMLTOOL --noout --del \
		'http://www.oasis-open.org/docbook/xml/simple/4.1.2.5' $CATALOG
}
