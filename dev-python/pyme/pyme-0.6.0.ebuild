# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyme/pyme-0.6.0.ebuild,v 1.6 2005/05/10 17:24:14 liquidx Exp $

inherit distutils

DESCRIPTION="GPGME Interface for Python"
SRC_URI="mirror://sourceforge/pyme/${P}.tar.gz"
HOMEPAGE="http://pyme.sourceforge.net"
DEPEND=">=app-crypt/gpgme-0.9.0"
SLOT="0"
KEYWORDS="x86 ~sparc ppc"
LICENSE="GPL-2"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:include/:include/gpgme/:' Makefile
}

src_compile() {
	emake swig
	distutils_src_compile
}

src_install() {
	mydoc="examples/*"
	distutils_src_install
	dohtml -r doc/*
}

src_test() {
	cd ${S}
	env PYTHONPATH=$(echo build/lib.*) \
	${python} examples/genkey.py || die "genkey test failed"
}

