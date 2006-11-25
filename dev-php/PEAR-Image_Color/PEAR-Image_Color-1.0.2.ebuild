# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Image_Color/PEAR-Image_Color-1.0.2.ebuild,v 1.4 2006/11/25 19:27:19 kloeri Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Manages and handles color data and conversions."

LICENSE="PHP"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

pkg_setup() {
	require_gd
}
