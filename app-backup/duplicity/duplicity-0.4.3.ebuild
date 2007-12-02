# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/duplicity/duplicity-0.4.3.ebuild,v 1.4 2007/12/02 08:55:40 ticho Exp $

inherit distutils eutils

DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-lang/python-2.3
	>=net-libs/librsync-0.9.6"
RDEPEND="${DEPEND}
	dev-python/py-gnupg
	>=dev-python/pexpect-2.1"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix behavior for scp:// URL when /bin/sh is bash, bug #151938.
	sed -i -e "s:echo -e:printf:" src/backends.py
}

src_compile() {
	distutils_src_compile
}

src_install() {
	python setup.py install --prefix="${D}"/usr
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/duplicity
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
