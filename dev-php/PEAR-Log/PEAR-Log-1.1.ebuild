# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Log/PEAR-Log-1.1.ebuild,v 1.9 2004/08/14 13:35:39 swegener Exp $

MY_P=${PN/PEAR-//}-${PV}
DESCRIPTION="The Log framework provides an abstracted logging system supporting logging to console, file, syslog, SQL, and mcal targets."
HOMEPAGE="http://pear.php.net/package-info.php?pacid=8"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="PHP"
SLOT="0"
# Afaik, anything that runs php will run this...
KEYWORDS="x86 ppc sparc"
DEPEND="virtual/php"
S=${WORKDIR}/${MY_P}
IUSE=""

src_install () {
	insinto /usr/lib/php/
	doins Log.php
	insinto /usr/lib/php/Log/
	doins Log/*
}
