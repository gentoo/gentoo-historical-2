# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/clientcookie/clientcookie-1.0.3.ebuild,v 1.2 2005/06/13 11:37:18 dholm Exp $

inherit distutils

MY_P="ClientCookie-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Python module for handling HTTP cookies on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientCookie/"
SRC_URI="http://wwwsearch.sourceforge.net/ClientCookie/src/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
DOCS="COPYING ChangeLog PKG-INFO README.txt"

src_install() {
	distutils_src_install
	dohtml README.html doc.html
}
