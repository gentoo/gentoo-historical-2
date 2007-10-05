# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File_Gettext/PEAR-File_Gettext-0.4.0.ebuild,v 1.11 2007/10/05 15:52:51 armin76 Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="GNU Gettext file parser."
LICENSE="PHP"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

pkg_setup() {
	require_php_with_use pcre
}
