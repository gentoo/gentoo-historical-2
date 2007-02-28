# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/turbocheetah/turbocheetah-0.9.5.ebuild,v 1.1 2007/02/28 00:11:37 dev-zero Exp $

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="~amd64 ~x86"

MY_PN=TurboCheetah
MY_P=${MY_PN}-${PV}

DESCRIPTION="TurboGears plugin to support use of Cheetah templates."
HOMEPAGE="http://www.turbogears.org/docs/plugins/template.html"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/cheetah-1.0"
DEPEND="${RDEPEND}
	test? ( dev-python/nose )
	dev-python/setuptools"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/install_requires = \[.*\],/d' \
		-e '/install_requires/, /],/d' \
		setup.py || die "sed failed"
}

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}
