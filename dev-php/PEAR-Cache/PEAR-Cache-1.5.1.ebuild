# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Cache/PEAR-Cache-1.5.1.ebuild,v 1.3 2003/02/13 11:29:01 vapier Exp $

P=${PN/PEAR-//}-${PV}
DESCRIPTION="Framework for caching of arbitrary data."
HOMEPAGE="http://pear.php.net/package-info.php?pacid=40"
SRC_URI="http://pear.php.net/get/${P}.tgz"
LICENSE="PHP"
SLOT="0"
# Afaik, anything that runs php will run this...
KEYWORDS="x86 ppc sparc"
DEPEND="virtual/php"

S=${WORKDIR}/${P}

src_install () {
	insinto /usr/lib/php/
	doins Cache.php
	insinto /usr/lib/php/Cache/
	# I dont know why the tarball isnt packaged the way it is supposed to be installed, but.....
	doins Application.php Container.php DB.php Error.php Function.php Graphics.php HTTP_Request.php Output.php OutputCompression.php
	insinto /usr/lib/php/Cache/Container/
	doins Container/*
	
}
