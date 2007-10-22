# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File/PEAR-File-1.3.0.ebuild,v 1.8 2007/10/22 16:38:26 armin76 Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Common file and directory routines"

LICENSE="PHP"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

pkg_setup() {
	require_php_with_use pcre
}
