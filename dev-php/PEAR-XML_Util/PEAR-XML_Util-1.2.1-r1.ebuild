# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-XML_Util/PEAR-XML_Util-1.2.1-r1.ebuild,v 1.1 2009/09/23 02:51:37 beandog Exp $

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

inherit depend.php

DESCRIPTION="XML utility class"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
PDEPEND="dev-php/pear"
HOMEPAGE="http://pear.php.net/package/XML_Util"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	require_php_with_use pcre
}

src_install() {
	insinto /usr/share/php/XML
	doins Util.php

	insinto /usr/share/php/docs/${MY_PN}
	doins examples/*
}
