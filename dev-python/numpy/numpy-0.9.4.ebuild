# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numpy/numpy-0.9.4.ebuild,v 1.3 2006/04/01 15:10:57 agriffis Exp $

inherit distutils

DESCRIPTION="Numpy contains a powerful N-dimensional array object for Python."
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://numeric.scipy.org/"
DEPEND=">=dev-lang/python-2.3
	virtual/lapack
	virtual/blas"
IUSE=""
SLOT="0"
KEYWORDS="~ia64 ~x86"
LICENSE="BSD"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s: f77blas: blas:g" \
		-e "s:'f77blas':'blas':g" \
		numpy/distutils/system_info.py
}

src_install() {
	distutils_src_install
	dodoc numpy/doc/*
}

