# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/propka/propka-3.1_p140511.ebuild,v 1.1 2014/05/11 10:44:32 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Prediction of the pKa values of ionizable groups in proteins and protein-ligand complexes"
HOMEPAGE="http://propka.ki.ku.dk/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

python_prepare_all() {
	sed -e "/exclude/s:scripts:\', \'Tests:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd Tests || die
	${PYTHON} runtest.py || die
}
