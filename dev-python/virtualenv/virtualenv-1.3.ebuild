# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/virtualenv/virtualenv-1.3.ebuild,v 1.2 2008/12/20 12:11:10 lu_zero Exp $

NEED_PYTHON="2.3"

inherit distutils

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="http://pypi.python.org/pypi/virtualenv"
SRC_URI="http://pypi.python.org/packages/source/v/${PN}/${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE=""
RDEPEND=">=dev-python/setuptools-0.6_rc8"
DEPEND="${RDEPEND}"
DOCS="docs/index.txt"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm support-files/ez_setup.py
}
