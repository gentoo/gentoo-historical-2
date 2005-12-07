# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numarray/numarray-1.5.0.ebuild,v 1.1 2005/12/07 12:05:41 liquidx Exp $

inherit distutils

DESCRIPTION="Numarray is an array processing package designed to efficiently manipulate large multi-dimensional arrays"
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/numarray"
DEPEND=">=dev-lang/python-2.3"
IUSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~s390 ~x86"
LICENSE="BSD"

src_install() {
	distutils_src_install
	dodoc Doc/*.txt LICENSE.txt
	cp -r Doc/*.py Doc/manual Doc/release_notes Examples ${D}/usr/share/doc/${PF}
}

