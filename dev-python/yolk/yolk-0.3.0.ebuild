# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/yolk/yolk-0.3.0.ebuild,v 1.2 2007/07/17 15:09:05 mr_bones_ Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="Tool and library for querying PyPI and locally installed Python packages"
HOMEPAGE="http://cheeseshop.python.org/pypi/yolk"
SRC_URI="http://cheeseshop.python.org/packages/source/y/yolk/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}
	dev-python/yolk-portage"

src_install() {
	distutils_src_install
	if use examples ; then
		docinto examples/plugins
		dodoc ${S}/examples/plugins/*
		docinto examples/plugins/yolk_portage
		dodoc ${S}/examples/plugins/yolk_portage/*
		docinto examples/plugins/yolk_pkg_manager
		dodoc ${S}/examples/plugins/yolk_pkg_manager/*
		prepalldocs
	fi
}
