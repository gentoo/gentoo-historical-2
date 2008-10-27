# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gadfly/gadfly-1.0.0.ebuild,v 1.16 2008/10/27 01:15:23 hawking Exp $

inherit python

DESCRIPTION="relational database system implemented in Python"
HOMEPAGE="http://gadfly.sourceforge.net/"
SRC_URI="mirror://sourceforge/gadfly/${P}.tar.gz"

KEYWORDS="amd64 ia64 ppc x86"
SLOT="0"
LICENSE="BSD"
IUSE=""

DEPEND="virtual/python"

src_compile() {
	python setup.py build || die "gadfly compilation failed"
	cd kjbuckets
	python setup.py build || die "kjbuckets compilation failed"
}

src_install() {
	python_need_rebuild
	dodoc *.txt doc/*.txt
	python setup.py install --root="${D}" || die
	cd kjbuckets
	python setup.py install --root="${D}" || die
}
