# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/testoob/testoob-1.13.ebuild,v 1.2 2009/09/07 02:50:12 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Advanced Python testing framework"
HOMEPAGE="http://testoob.sourceforge.net/"
SRC_URI="mirror://sourceforge/testoob/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE="pdf threads"

DEPEND=""
RDEPEND="dev-python/4suite
	pdf? ( dev-python/reportlab )
	threads? ( dev-python/twisted )"
RESTRICT_PYTHON_ABIS="3.*"

DOCS="docs/*"

src_test() {
	testing() {
		PATH="build-${PYTHON_ABI}/scripts-${PYTHON_ABI}:${PATH}" PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/alltests.py
	}
	python_execute_function testing
}
