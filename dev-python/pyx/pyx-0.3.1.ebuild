# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyx/pyx-0.3.1.ebuild,v 1.4 2003/07/12 12:49:26 aliz Exp $

IUSE=""

inherit distutils

MY_P=${P/pyx/PyX}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Python package for the generation of encapsulated PostScript figures"
SRC_URI="mirror://sourceforge/pyx/${MY_P}.tar.gz"
HOMEPAGE="http://pyx.sourceforge.net/"

DEPEND=">=dev-lang/python-2.2"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"


src_install() {

	DOCS="manual/manual.ps"
	distutils_src_install
	
	insinto /usr/share/doc/${PF}/examples
	doins examples/*

}




