# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-evolution/django-evolution-0.6.7-r1.ebuild,v 1.4 2013/03/15 09:33:33 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} pypy{1_9,2_0} )

inherit distutils-r1 eutils

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Django application that will run cron jobs for other django apps"
HOMEPAGE="http://code.google.com/p/django-evolution/ http://pypi.python.org/pypi/django_evolution/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/django
	test? ( dev-python/nose )"

S=${WORKDIR}/${MY_P}

python_test() {
	# This is tested, any delay in die subsequent to (implicitly inherited) multiprocessing eclass
	"${PYTHON}" tests/runtests.py || die
}

src_install() {
	distutils-r1_src_install

	einfo "Remove tests to avoid file collisions"
	rm -rf $(find "${ED}" -name tests) || die

	dodoc -r docs/
}
