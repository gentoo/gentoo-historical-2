# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/duplicity/duplicity-0.4.2.ebuild,v 1.3 2006/04/30 16:06:59 dertobi123 Exp $

inherit distutils

IUSE=""
DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

DEPEND="virtual/libc
	>=dev-lang/python-2.3
	>=net-libs/librsync-0.9.6"
RDEPEND="${DEPEND}
	app-crypt/gnupg"

src_compile() {
	distutils_src_compile
}

src_install() {
	python setup.py install --prefix=${D}/usr
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/duplicity
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
