# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/creole/creole-1.0.2.ebuild,v 1.3 2006/01/01 17:00:32 sebastian Exp $

inherit php-pear-lib-r1

KEYWORDS="~x86 ~amd64"
DESCRIPTION="Database abstraction layer for PHP 5."
HOMEPAGE="http://creole.phpdb.org/wiki/"
SRC_URI="http://creole.phpdb.org/pear/${P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="${RDEPEND} >=dev-php5/jargon-1.0.2"

need_php_by_category
