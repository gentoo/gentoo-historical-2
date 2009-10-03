# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/foolscap/foolscap-0.4.2.ebuild,v 1.2 2009/10/03 09:54:44 maekke Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="The next-generation RPC protocol, intended to replace Perspective Broker."
HOMEPAGE="http://foolscap.lothar.com/trac"
SRC_URI="http://${PN}.lothar.com/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~s390 x86"
IUSE="doc"

RDEPEND=">=dev-python/twisted-2.4.0"
DEPEND="${DEPEND}
		dev-python/setuptools"

RESTRICT_PYTHON_ABIS="3*"

src_install() {
	distutils_src_install

	if use doc; then
		dodoc doc/*.txt || die "dodoc failed"
		dohtml -A py,tpl,xhtml -r doc/* || die "dohtml failed"
	fi
}

src_test() {
	testing() {
		LC_ALL="C" PYTHONPATH="build-${PYTHON_ABI}/lib" trial ${PN}
	}
	python_execute_function testing
}
