# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/routes/routes-1.6.2.ebuild,v 1.1 2007/02/27 23:22:24 dev-zero Exp $

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="~amd64 ~x86"

MY_PN=Routes
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Python re-implementation of the Rails routes system for mapping URL's to Controllers/Actions."
HOMEPAGE="http://routes.groovie.org"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE="doc test"

DEPEND="doc? ( dev-python/buildutils dev-python/pudge )
	test? ( dev-python/nose )
	dev-python/setuptools"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/use_setuptools/d' \
		setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile
	if use doc ; then
		einfo "Generating docs as requested..."
		PYTHONPATH=. "${python}" setup.py pudge || die "generating docs failed"
	fi
}

src_install() {
	distutils_src_install
	use doc && dohtml -r docs/html/*
}

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "test failed"
}
