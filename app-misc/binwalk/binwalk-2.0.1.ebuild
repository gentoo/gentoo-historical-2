# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/binwalk/binwalk-2.0.1.ebuild,v 1.1 2014/11/20 17:26:54 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_P=${P/_p/-}
DESCRIPTION="A tool for identifying files embedded inside firmware images"
HOMEPAGE="https://github.com/devttys0/binwalk"
SRC_URI="https://github.com/devttys0/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graph"

RDEPEND="
	app-crypt/ssdeep
	sys-apps/file[python]
	graph? ( dev-python/pyqtgraph[opengl,${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-libs.patch
)

python_configure_all() {
	econf --disable-bundles
}

python_compile_all() {
	emake
}

python_install_all() {
	local DOCS=( API.md INSTALL.md )
	distutils-r1_python_install_all

	dolib.so src/C/*/*.so
}
