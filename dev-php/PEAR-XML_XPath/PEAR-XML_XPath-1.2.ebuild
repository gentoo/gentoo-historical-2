# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Authore: Tom von Schwerdtner <tvon@etria.org>
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-XML_XPath/PEAR-XML_XPath-1.2.ebuild,v 1.6 2004/06/25 01:22:13 agriffis Exp $

MY_P=${PN/PEAR-//}-${PV}
DESCRIPTION="The PEAR::XML_XPath class provided an XPath/DOM XML manipulation, maneuvering and query interface"
HOMEPAGE="http://pear.php.net/package-info.php?pacid=65"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="PHP"
SLOT="0"
# Afaik, anything that runs php will run this...
KEYWORDS="x86 ppc sparc"
DEPEND="virtual/php"
IUSE=""
S=${WORKDIR}/${MY_P}

src_install () {
	insinto /usr/lib/php/XML
	doins XPath.php
	insinto /usr/lib/php/XML/XPath/
	doins XPath/*
}

pkg_postinst () {
	einfo
	einfo "NOTE: This package requires the domxml extension."
	einfo "To enable domxml, add xml2 to your USE settings"
	einfo "and re-merge php."
	einfo
}
