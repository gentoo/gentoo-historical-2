# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Date/PEAR-Date-1.3.ebuild,v 1.6 2004/06/25 01:17:41 agriffis Exp $

IUSE=""
MY_P=${PN/PEAR-//}-${PV}
DESCRIPTION="Date and Time Zone Classes"
HOMEPAGE="http://pear.php.net/package-info.php?pacid=57"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="PHP"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
DEPEND="virtual/php"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

src_install () {
	insinto /usr/lib/php
	doins Date.php
	insinto /usr/lib/php/Date
	doins Date/Calc.php
	doins Date/Human.php
	doins Date/TimeZone.php
}
