# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tpg/tpg-3.0.2.ebuild,v 1.2 2004/05/02 12:00:47 dholm Exp $

inherit distutils

MY_P="TPG-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Toy Parser Generator for Python"
HOMEPAGE="http://christophe.delord.free.fr/en/tpg/"
SRC_URI="http://christophe.delord.free.fr/soft/tpg/${MY_P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc"
IUSE="doc"

DEPEND="virtual/python"

DOCS="License.txt THANKS"

src_install() {
	distutils_src_install
	use doc && ( dohtml doc/*
			insinto /usr/share/doc/${PF}/examples
			doins examples/* )
}
