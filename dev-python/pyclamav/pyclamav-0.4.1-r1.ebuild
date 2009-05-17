# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyclamav/pyclamav-0.4.1-r1.ebuild,v 1.1 2009/05/17 08:09:01 dertobi123 Exp $

EAPI=2

NEED_PYTHON=2.2

inherit distutils eutils

DESCRIPTION="Python binding for libclamav"
HOMEPAGE="http://xael.org/norman/python/pyclamav/"
SRC_URI="http://xael.org/norman/python/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
DEPEND=">=app-antivirus/clamav-0.90"
SLOT="0"
IUSE=""

src_prepare() {
	# Patch from Debian to build w/ >=clamav-0.95
	epatch "${FILESDIR}/${P}-clamav-0.95.patch"
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF} && doins example.py
}

pkg_postinst() {
	elog "Due to removal of cl_scanbuff in libclamav, pyclamav.scanthis()"
	elog "has been removed in this release. Authors strongly encourage to use"
	elog "pyClamd (http://xael.org/norman/python/pyclamd)."
}
