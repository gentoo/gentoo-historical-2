# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zodb/zodb-3.3.1.ebuild,v 1.4 2006/11/23 19:36:12 blubb Exp $

inherit distutils

MY_P=ZODB
DESCRIPTION="Zope Object DataBase"
HOMEPAGE="http://zope.org/Products/ZODB3.3"
SRC_URI="http://zope.org/Products/${MY_P}3.3/${MY_P}%20${PV}/${MY_P}3-${PV}.tgz"

LICENSE="ZPL"
SLOT="3.3"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3.4"

S=${WORKDIR}/${MY_P}3-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}/${ZPROD_LIST}
	epatch ${FILESDIR}/${PF}_umaskbug.patch
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
	dohtml -a html -r Doc ExtensionClass
}
