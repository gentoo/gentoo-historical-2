# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zopeinterface/zopeinterface-3.5.1.ebuild,v 1.3 2009/06/26 06:06:26 jer Exp $

NEED_PYTHON=2.5

inherit distutils

MY_PN="zope.interface"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zope 3 Interface Infrastructure"
HOMEPAGE="http://pypi.python.org/pypi/zope.interface"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools
	!net-zope/zodb"

S=${WORKDIR}/${MY_P}

src_install() {
	DOCS="CHANGES.txt README.txt src/zope/interface/*.txt"
	distutils_src_install
	rm -fr "${D}$(python_get_sitedir)/zope/interface"/{tests,common/tests,*.txt,*.c}
}
