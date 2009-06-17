# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qbzr/qbzr-0.11.0.ebuild,v 1.2 2009/06/17 07:30:42 pva Exp $

NEED_PYTHON=2.4

inherit distutils versionator

DESCRIPTION="Qt frontend for Bazaar"
HOMEPAGE="https://launchpad.net/qbzr"
SRC_URI="http://launchpad.net/qbzr/trunk/${PV}/+download/${PN}-${PV/.0}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-util/bzr-1.9
		>=dev-python/PyQt4-4.1"
RDEPEND="${DEPEND}"

DOCS="AUTHORS.txt NEWS.txt README.txt TODO.txt"

S=${WORKDIR}/${PN}

PYTHON_MODNAME=bzrlib

src_test() {
	elog "It's impossible to run tests at this point. If you wish to run tests"
	elog "after installation of ${PN} execute:"
	elog " $ bzr selftest -s bzrlib.plugins.qbzr"
}

pkg_postinst() {
	distutils_pkg_postinst
	elog
	elog "To enable spellchecking in qcommit, please, install >=dev-python/pyenchant-1.5.0"
	elog " # emerge -a >=dev-python/pyenchant-1.5.0"
	elog "To enable syntax highlighting, please, install dev-python/pygments"
	elog " # emerge -a dev-python/pygments"
}
