# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/clientform/clientform-0.1.15.ebuild,v 1.1 2004/03/10 00:20:18 kloeri Exp $

inherit distutils

MY_P="ClientForm-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Parse, fill out, and return HTML forms on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientForm/"
SRC_URI=http://wwwsearch.sourceforge.net/ClientForm/src/${MY_P}.tar.gz
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DOCS="COPYING README.txt PKG-INFO MANIFEST.in ChangeLog"

src_install() {
	distutils_src_install
	dohtml README.html
}
