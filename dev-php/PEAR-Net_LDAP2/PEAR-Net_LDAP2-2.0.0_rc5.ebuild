# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_LDAP2/PEAR-Net_LDAP2-2.0.0_rc5.ebuild,v 1.1 2009/03/07 05:52:49 darkside Exp $

inherit php-pear-r1 depend.php

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
need_php5

pkg_setup() {
	require_php_with_use ldap
}
