# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/egenix-mx-base/egenix-mx-base-2.0.3.ebuild,v 1.14 2004/03/16 19:28:31 kloeri Exp $

inherit flag-o-matic

S=${WORKDIR}/${P}
DESCRIPTION="egenix utils for Python."
SRC_URI="http://www.egenix.com/files/python/${P}.tar.gz"
HOMEPAGE="http://www.egenix.com/"

DEPEND="virtual/python"
RDEPEND="${RDEPEND}"

SLOT="0"
KEYWORDS="x86 sparc alpha"
LICENSE="eGenixPublic"
#please note, there is also a possibility to buy a commercial license
#from egenix.com

src_compile() {
	replace-flags "-O[3s]" "-O2"
	python setup.py build || die
}

src_install() {
	python setup.py install --prefix=${D}/usr || die
	dohtml -a html -r mx
}
