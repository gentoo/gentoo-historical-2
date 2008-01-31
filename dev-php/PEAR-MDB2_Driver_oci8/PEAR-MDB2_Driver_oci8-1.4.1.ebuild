# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2_Driver_oci8/PEAR-MDB2_Driver_oci8-1.4.1.ebuild,v 1.5 2008/01/31 23:17:52 ranger Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Database Abstraction Layer, oci8 driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc -ppc64 ~sparc x86"
IUSE=""

DEPEND="dev-php/PEAR-MDB2"
RDEPEND="${DEPEND}"

pkg_setup() {
	has_php
	require_php_with_any_use oci8 oci8-instant-client
}
