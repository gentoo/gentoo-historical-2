# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/yolk/yolk-0.0.7-r1.ebuild,v 1.1 2007/04/23 18:35:43 pythonhead Exp $

inherit distutils eutils

NEED_PYTHON=2.4
DESCRIPTION="Tool and library for querying PyPI and packages installed by setuptools"
HOMEPAGE="http://cheeseshop.python.org/pypi/yolk"
SRC_URI="http://cheeseshop.python.org/packages/source/y/yolk/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="test examples"
RDEPEND="|| ( >=dev-lang/python-2.5 dev-python/elementtree )
	dev-python/setuptools
	test? ( dev-python/nose )
	dev-python/yolk-portage"


src_unpack() {
	unpack ${A}
	cd ${S}
	#Avoid traceback from users botched egg removal.
	epatch ${FILESDIR}/${P}-bad-egg.patch
}

src_install() {
	distutils_src_install
	if use examples ; then
		dodir /usr/share/doc/${P}/examples
		cp -r examples/* ${D}/usr/share/doc/${P}/examples
	fi
}

src_test() {
	nosetests || die "nose test failed"
}

