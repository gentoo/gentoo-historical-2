# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zopeinterface/zopeinterface-3.0.1.ebuild,v 1.22 2008/10/25 13:58:21 hawking Exp $

inherit distutils

MY_PN="ZopeInterface"
DESCRIPTION="Standalone Zope interface library"
HOMEPAGE="http://pypi.python.org/pypi/zope.interface/"
SRC_URI="http://www.zope.org/Products/${MY_PN}/${PV}final/${MY_PN}-${PV}.tgz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="doc"

RDEPEND=">=dev-lang/python-2.3"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gcc4.patch
}

src_install() {
	distutils_src_install
	if use doc ; then
		cp -pR $MY_PN "${D}"/usr/share/doc/${PF}/
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
}
