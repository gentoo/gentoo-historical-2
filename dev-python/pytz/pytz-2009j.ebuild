# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytz/pytz-2009j.ebuild,v 1.6 2009/07/27 13:11:26 ranger Exp $

EAPI="2"

NEED_PYTHON="2.3"

inherit eutils distutils

DESCRIPTION="World Timezone Definitions for Python"
HOMEPAGE="http://pytz.sourceforge.net/"
SRC_URI="http://cheeseshop.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/timezone-data-${PV}"
DEPEND="${RDEPEND}"

DOCS="CHANGES.txt"

src_prepare() {
	# Use timezone-data zoneinfo.
	epatch "${FILESDIR}/${PN}-2009j-zoneinfo.patch"
}

src_test() {
	PYTHONPATH=. "${python}" pytz/tests/test_tzinfo.py || die "test failed"
}

src_install() {
	distutils_src_install
	rm -rf "${D}"/usr/lib*/python*/site-packages/pytz/zoneinfo
}
