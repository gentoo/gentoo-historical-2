# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File/PEAR-File-1.2.2.ebuild,v 1.17 2008/01/10 10:06:21 vapier Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Common file and directory routines"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

pkg_setup() {
	require_php_with_use pcre
}
