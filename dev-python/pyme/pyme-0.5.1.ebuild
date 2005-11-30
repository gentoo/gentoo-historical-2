# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyme/pyme-0.5.1.ebuild,v 1.1 2002/11/27 04:27:05 jrray Exp $

IUSE=""

S=${WORKDIR}/${P}

DESCRIPTION="GPGME Interface for Python"
MY_P=${P/-/_}
SRC_URI="http://gopher.quux.org:70/devel/pyme/${MY_P}.tar.gz"
HOMEPAGE="http://gopher.quux.org:70/devel/pyme"

DEPEND=">=app-crypt/gpgme-0.3.9"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

inherit distutils

src_install() {
	mydoc="examples/*"
	distutils_src_install
	dohtml -r doc/*
}
