# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/clientcookie/clientcookie-0.4.19.ebuild,v 1.3 2004/06/27 18:09:35 pythonhead Exp $

inherit distutils

MY_P="ClientCookie-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Python module for handling HTTP cookies on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientCookie/"
SRC_URI="http://wwwsearch.sourceforge.net/ClientCookie/src/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DOCS="COPYING ChangeLog PKG-INFO README.txt"

src_install() {
	distutils_src_install
	dohtml README.html doc.html
}

