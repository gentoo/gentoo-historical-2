# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-System_Command/PEAR-System_Command-1.0.ebuild,v 1.3 2003/02/13 11:29:24 vapier Exp $

P=${PN/PEAR-//}-${PV}
DESCRIPTION="PEAR::System_Command is a commandline execution interface"
HOMEPAGE="http://pear.php.net/package-info.php?pacid=74"
SRC_URI="http://pear.php.net/get/${P}.tgz"
LICENSE="PHP"
SLOT="0"
# Afaik, anything that runs php will run this...
KEYWORDS="x86 ppc sparc"
DEPEND="virtual/php"

S=${WORKDIR}/${P}

src_install () {
	insinto /usr/lib/php/
	doins Command.php
}
