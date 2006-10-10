# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-Mail/ezc-Mail-1.0.1.ebuild,v 1.5 2006/10/10 08:56:45 sebastian Exp $

inherit php-ezc depend.php

DESCRIPTION="This eZ component allows you construct Mail messages conforming to the RFCs."
SLOT="0"
KEYWORDS="~ppc ~ppc64 ~x86 ~amd64"
IUSE=""

pkg_setup() {
	require_php_with_use iconv
}
