# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgcore-checks/pkgcore-checks-0.4.ebuild,v 1.2 2007/06/07 11:13:53 armin76 Exp $

inherit distutils

DESCRIPTION="pkgcore developmental repoman replacement"
HOMEPAGE="http://www.pkgcore.org/"
SRC_URI="http://www.pkgcore.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ia64 ~x86"
IUSE=""

RDEPEND=">=sys-apps/pkgcore-0.3
	dev-python/snakeoil
	>=dev-lang/python-2.4"
DEPEND="${RDEPEND}"

DOCS="NEWS AUTHORS"

PYTHON_MODNAME=pkgcore_checks

src_test() {
	"${python}" setup.py test || die "tests returned non zero"
}

pkg_postinst() {
	einfo "updating pkgcore plugin cache"
	pplugincache pkgcore_checks.plugins pkgcore.plugins
	# This is left behind by pkgcore-checks 0.3.
	rm -f "${ROOT}"usr/lib/python${PYVER}/site-packages/pkgcore_checks/plugins/plugincache
	distutils_pkg_postinst
}

pkg_postrm() {
	python_version
	# Careful not to remove this on up/downgrades.
	local sitep="${ROOT}"usr/lib/python${PYVER}/site-packages
	if [[ -e "${sitep}/pkgcore_checks/plugins/plugincache2" ]] &&
		! [[ -e "${sitep}/pkgcore_checks/base.py" ]]; then
		rm "${sitep}/pkgcore_checks/plugins/plugincache2"
	fi
	distutils_pkg_postrm
}
