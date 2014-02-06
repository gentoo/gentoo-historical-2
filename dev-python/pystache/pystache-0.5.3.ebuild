# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pystache/pystache-0.5.3.ebuild,v 1.1 2014/02/06 16:58:41 bicatali Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_3} )
inherit distutils-r1

DESCRIPTION="Mustache for Python"
HOMEPAGE="http://github.com/defunkt/pystache"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
