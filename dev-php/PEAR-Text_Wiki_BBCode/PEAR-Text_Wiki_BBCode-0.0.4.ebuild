# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Text_Wiki_BBCode/PEAR-Text_Wiki_BBCode-0.0.4.ebuild,v 1.2 2007/12/06 00:55:49 jokey Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="BBCode parser for Text_Wiki."

LICENSE="LGPL-2.1 PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-Text_Wiki-1.0.3"

pkg_setup() {
	require_php_with_use pcre
}
