# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Authore: Tom von Schwerdtner <tvon@etria.org>
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-XML_CSSML/PEAR-XML_CSSML-1.1.ebuild,v 1.5 2004/04/17 15:02:28 aliz Exp $

MY_P=${PN/PEAR-//}-${PV}
DESCRIPTION="A template system for generating cascading style sheets (CSS)"
HOMEPAGE="http://pear.php.net/package-info.php?pacid=61"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="PHP"
SLOT="0"
# Afaik, anything that runs php will run this...
KEYWORDS="x86 ppc sparc"
DEPEND="virtual/php"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install () {
	insinto /usr/lib/php/XML
	doins CSSML.php
	insinto /usr/lib/php/XML/CSSML/
	doins CSSML/*
}
