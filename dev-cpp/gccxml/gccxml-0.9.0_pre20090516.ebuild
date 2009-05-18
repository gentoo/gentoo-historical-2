# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gccxml/gccxml-0.9.0_pre20090516.ebuild,v 1.3 2009/05/18 20:23:16 ranger Exp $

inherit eutils toolchain-funcs

DESCRIPTION="XML output extension to GCC"
HOMEPAGE="http://www.gccxml.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~mips ppc ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=">=dev-util/cmake-2.4.6"
RDEPEND=""

S="${WORKDIR}/${P}"
MYBUILDDIR="${WORKDIR}/build"

src_unpack() {
	mkdir "${MYBUILDDIR}"
	unpack ${A}

	cd "${S}"
	# patch below taken from Debian
	sed -i \
		-e 's/xatexit.c//' \
		"${S}/GCC/libiberty/CMakeLists.txt" || die "sed failed"
}
src_compile() {
	cd "${MYBUILDDIR}"
	cmake "${S}" \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCMAKE_CXX_COMPILER:FILEPATH="$(tc-getCXX)" \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_C_COMPILER:FILEPATH="$(tc-getCC)" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		|| die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	cd "${MYBUILDDIR}"
	emake DESTDIR="${D}" install || die "emake install failed"
}
