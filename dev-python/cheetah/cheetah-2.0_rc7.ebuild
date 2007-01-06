# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cheetah/cheetah-2.0_rc7.ebuild,v 1.1 2007/01/06 22:29:36 dev-zero Exp $

inherit distutils

MY_P=${P/ch/Ch}
MY_P=${MY_P/_rc/rc}

DESCRIPTION="Python-powered template engine and code generator."
HOMEPAGE="http://www.cheetahtemplate.org/"
SRC_URI="mirror://sourceforge/cheetahtemplate/${MY_P}.tar.gz"
LICENSE="PSF-2.2"
IUSE=""
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc-macos ~sparc ~x86"
SLOT="0"
DEPEND=">=dev-lang/python-2.2"
S=${WORKDIR}/${MY_P}

PYTHON_MODNAME="Cheetah"
DOCS="README CHANGES TODO"

pkg_postinst() {
	ewarn "This release requires re-compilation of all compiled templates!"
}

src_test() {
	cd src/Tests
	python Test.py || die "tests failed"
}
