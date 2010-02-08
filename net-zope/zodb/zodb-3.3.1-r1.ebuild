# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zodb/zodb-3.3.1-r1.ebuild,v 1.4 2010/02/08 09:01:24 pva Exp $
EAPI=2

inherit eutils distutils

MY_P=ZODB
DESCRIPTION="Zope Object DataBase"
HOMEPAGE="http://zope.org/Products/ZODB3.3"
SRC_URI="http://zope.org/Products/${MY_P}3.3/${MY_P}%20${PV}/${MY_P}3-${PV}.tgz"

LICENSE="ZPL"
SLOT="3.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="<dev-lang/python-2.5"
DEPEND="${RDEPEND}
	!net-zope/zope-interface"

S=${WORKDIR}/${MY_P}3-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PF}_umaskbug.patch \
		"${FILESDIR}"/${P}-CVE-2009-0668+0669.patch
}

src_install() {
	distutils_src_install
	dohtml -a html -r Doc ExtensionClass
}
