# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:

P=${PN/PEAR-//}-${PV}
DESCRIPTION="The Log framework provides an abstracted logging system supporting logging to console, file, syslog, SQL, and mcal targets."
HOMEPAGE="http://pear.php.net/package-info.php?pacid=8"
SRC_URI="http://pear.php.net/get/${P}.tgz"
LICENSE="PHP"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~sparc64 ~alpha"
DEPEND="virtual/php"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${P}

src_install () {
	insinto /usr/lib/php/
	doins Log.php
	insinto /usr/lib/php/Log/
	doins Log/*
}
