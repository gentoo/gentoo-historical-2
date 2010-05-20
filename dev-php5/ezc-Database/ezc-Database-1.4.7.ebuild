# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-Database/ezc-Database-1.4.7.ebuild,v 1.1 2010/05/20 04:14:45 pva Exp $

EZC_BASE_MIN="1.8"
inherit php-ezc depend.php

DESCRIPTION="This eZ component provides a lightweight database layer on top of PDO."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

pkg_setup() {
	require_php_with_use pdo
}
