# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pydispatcher/pydispatcher-1.0.0.ebuild,v 1.4 2005/04/17 19:39:49 luckyduck Exp $

inherit distutils

MY_PN="PyDispatcher"

DESCRIPTION="Multi-producer-multi-consumer signal dispatching mechanism for Python"
HOMEPAGE="http://pydispatcher.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE=""
DEPEND="virtual/python"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	distutils_src_install
	distutils_python_version
	dohtml -r ${D}/usr/lib/python${PYVER}/site-packages/dispatch/docs/*
	rm -r ${D}/usr/lib/python${PYVER}/site-packages/dispatch/docs
}
