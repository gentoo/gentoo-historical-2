# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/transmissionrpc/transmissionrpc-0.7.ebuild,v 1.2 2011/09/09 20:40:39 floppym Exp $

EAPI=3

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.[45] 3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Python module that implements the Transmission bittorrent client RPC protocol"
HOMEPAGE="https://bitbucket.org/blueluna/transmissionrpc"
# SRC_URI="https://bitbucket.org/blueluna/${PN}/get/release-${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI="http://dev.gentoo.org/~floppym/distfiles/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

src_unpack() {
	default
	mv blueluna-${PN}-* "${S}" || die
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-timestamp-test.patch"
	distutils_src_prepare
}
