# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/creole/creole-1.0.2.ebuild,v 1.5 2005/10/12 11:14:13 humpback Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Database abstraction layer for PHP 5."
HOMEPAGE="http://creole.phpdb.org/wiki/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
SRC_URI="http://creole.phpdb.org/pear/creole-${PV}.tgz"
RDEPEND=">=dev-php/jargon-1.0.2"

need_php5
