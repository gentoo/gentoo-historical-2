# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/PEAR-XML_XPath/PEAR-XML_XPath-1.2.2.ebuild,v 1.3 2006/01/21 20:29:38 corsair Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="The PEAR::XML_XPath class provided an XPath/DOM XML manipulation, maneuvering and query interface"
LICENSE="PHP"
SLOT="0"
KEYWORDS="~ppc ppc64 ~sparc ~x86"
IUSE=""

pkg_postinst () {
	ewarn "The XML_XPath PEAR package is unmaintained and requires"
	ewarn "PHP 4 built with the DOMXML extension (USE=xml2)."
}

need_php_by_category
