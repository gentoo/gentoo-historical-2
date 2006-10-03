# Copyright 1999-2006 Gentoo Foundation and Thomas Capricelli <orzel@kde.org>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/boson/boson-0.13.ebuild,v 1.1 2006/10/03 09:03:57 nyhm Exp $

inherit eutils kde-functions toolchain-funcs

MY_P=${PN}-all-${PV}
DESCRIPTION="real-time strategy game, with the feeling of Command&Conquer(tm)"
HOMEPAGE="http://boson.sourceforge.net/"
SRC_URI="mirror://sourceforge/boson/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc -sparc ~x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/openal"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.2"
need-kde 3

S=${WORKDIR}/${MY_P}/build

src_unpack() {
	unpack ${A}
	cd ${MY_P}
	mkdir build

	# Sandbox fix
	sed -i '/^kde3_install_icons/d' \
		code/boson/data/CMakeLists.txt \
		|| die "sed failed"
}

src_compile() {
	cmake \
		-DCMAKE_C_COMPILER=$(which $(tc-getCC)) \
		-DCMAKE_CXX_COMPILER=$(which $(tc-getCXX)) \
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DKDEDIR=$(kde-config --prefix) \
		.. || die "cmake failed"

	emake || die "emake failed"
}

src_install() {
	dodoc ../code/{AUTHORS,ChangeLog,README}

	newicon ../code/boson/data/hi48-app-boson.png ${PN}.png

	emake DESTDIR="${D}" install || die "emake install failed"
}
