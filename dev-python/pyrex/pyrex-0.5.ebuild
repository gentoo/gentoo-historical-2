# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyrex/pyrex-0.5.ebuild,v 1.10 2004/05/04 12:19:45 kloeri Exp $

inherit distutils

MY_P="Pyrex-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="a language for writing Python extension modules"
HOMEPAGE="http://www.cosc.canterbury.ac.nz/~greg/python/Pyrex"
SRC_URI="http://www.cosc.canterbury.ac.nz/~greg/python/Pyrex/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="virtual/python"
RDEPEND=""

src_install() {
	mydoc="CHANGES.txt INSTALL.txt README.txt USAGE.txt"
	distutils_src_install

	dodir ${D}usr/share/doc/${PF}/Demos
	cp -r ${S}/Demos ${D}usr/share/doc/${PF}
	dohtml -r Doc/*
	cp ${S}/Doc/primes.c ${D}usr/share/doc/${PF}/html/
}
