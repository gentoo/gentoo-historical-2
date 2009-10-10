# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/clientcookie/clientcookie-1.3.0.ebuild,v 1.3 2009/10/10 12:39:31 grobian Exp $

inherit distutils

MY_P="ClientCookie-${PV}"
DESCRIPTION="Python module for handling HTTP cookies on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientCookie/"
SRC_URI="http://wwwsearch.sourceforge.net/ClientCookie/src/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE=""

S="${WORKDIR}/${MY_P}"
DOCS="*.txt"

src_unpack() {
	unpack ${A}
	cd ${S}

	# use distutils instead of setuptools
	sed -e 's/not hasattr(sys, "version_info")/1/' -i setup.py
}

src_install() {
	# remove to prevent distutils_src_install from installing it
	dohtml *.html
	rm README.html*

	distutils_src_install
}
