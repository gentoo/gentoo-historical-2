# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgcore-checks/pkgcore-checks-0.3.3.ebuild,v 1.2 2007/06/06 21:12:16 marienz Exp $

inherit distutils eutils

DESCRIPTION="pkgcore developmental repoman replacement"
HOMEPAGE="http://www.pkgcore.org/"
SRC_URI="http://www.pkgcore.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-apps/pkgcore-0.2.3
	<sys-apps/pkgcore-0.3
	>=dev-lang/python-2.4"
DEPEND=">=dev-lang/python-2.4"

DOCS="NEWS AUTHORS"

PYTHON_MODNAME=pkgcore_checks

src_test() {
	"${python}" setup.py test || die "tests returned non zero"
}

pkg_postinst() {
	einfo "updating pkgcore plugin cache"
	pplugincache pkgcore_checks.plugins pkgcore.plugins
}
