# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/apse/apse-0.2.ebuild,v 1.1 2005/01/24 17:58:59 satya Exp $

inherit distutils
MY_PN="${PN/apse/Apse}"

DESCRIPTION="Approximate String Matching in Python: identifies typing and spelling errors, closely related vocabularies, genetic mutations (GAG ACT), abbreviations"
HOMEPAGE="http://www.personal.psu.edu/staff/i/u/iua1/python/apse/"
SRC_URI="http://www.personal.psu.edu/staff/i/u/iua1/python/apse/dist/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

DEPEND="dev-lang/python
	dev-lang/swig"

S=${WORKDIR}/${MY_PN}-${PV}

PYTHON_MODNAME="Apse"

src_install() {
	distutils_src_install
	#dodir /usr/share/doc/${PF}
	dodoc README* *agrep
	insinto /usr/share/doc/test
	doins test/*
}

