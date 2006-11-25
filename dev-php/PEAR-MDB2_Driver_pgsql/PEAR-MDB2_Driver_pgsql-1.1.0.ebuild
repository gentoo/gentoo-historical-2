# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2_Driver_pgsql/PEAR-MDB2_Driver_pgsql-1.1.0.ebuild,v 1.2 2006/11/25 19:33:11 kloeri Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Database Abstraction Layer, pgsql driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-php/PEAR-MDB2"
RDEPEND="${DEPEND}"

pkg_setup() {
	has_php
	require_php_with_use postgres
}
