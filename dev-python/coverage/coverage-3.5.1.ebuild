# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/coverage/coverage-3.5.1.ebuild,v 1.6 2012/03/20 08:24:32 ago Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="http://nedbatchelder.com/code/coverage/ http://pypi.python.org/pypi/coverage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODNAME="coverage"
