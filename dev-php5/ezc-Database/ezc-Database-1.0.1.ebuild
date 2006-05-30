# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-Database/ezc-Database-1.0.1.ebuild,v 1.2 2006/05/30 11:25:41 corsair Exp $

inherit php-ezc depend.php

DESCRIPTION="This eZ component provides a lightweight database layer on top of PDO."
SLOT="0"
KEYWORDS="~ppc64 ~x86"
IUSE=""

pkg_setup() {
	require_pdo
}
