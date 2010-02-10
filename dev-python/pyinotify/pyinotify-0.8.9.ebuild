# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyinotify/pyinotify-0.8.9.ebuild,v 1.3 2010/02/10 05:20:07 josejx Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python module used for monitoring filesystems events"
HOMEPAGE="http://trac.dbzteam.org/pyinotify http://pypi.python.org/pypi/pyinotify"
SRC_URI="http://seb.dbzteam.org/pub/pyinotify/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

PYTHON_MODNAME="pyinotify.py"

src_install() {
	distutils_src_install

	if use doc; then
		docinto html/python2
		dohtml python2/docstrings/* || die "dohtml failed"
		docinto html/python3
		dohtml python3/docstrings/* || die "dohtml failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins python2/examples/* || die "doins failed"
	fi
}
