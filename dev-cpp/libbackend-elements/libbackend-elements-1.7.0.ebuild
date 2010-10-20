# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libbackend-elements/libbackend-elements-1.7.0.ebuild,v 1.1 2010/10/20 05:56:23 dev-zero Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="A collection of elementary building blocks for implementing compiler backends in c++."
HOMEPAGE="http://kolpackov.net/projects/libbackend-elements/"
SRC_URI="ftp://kolpackov.net/pub/projects/${PN}/${PV%.?}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-cpp/libcult-1.4.3
	dev-libs/boost"
DEPEND="${RDEPEND}
	dev-util/build"

src_configure() {
	mkdir -p build/{c,cxx/gnu,import/libboost,import/libcult}

	cat >> build/c/configuration-lib-dynamic.make <<- EOF
c_lib_type   := shared
	EOF

	cat >> build/cxx/configuration-dynamic.make <<- EOF
cxx_id       := gnu
cxx_optimize := n
cxx_debug    := n
cxx_rpath    := n
cxx_pp_extra_options :=
cxx_extra_options    := ${CXXFLAGS}
cxx_ld_extra_options := ${LDFLAGS}
cxx_extra_libs       :=
cxx_extra_lib_paths  :=
	EOF

	cat >> build/cxx/gnu/configuration-dynamic.make <<- EOF
cxx_gnu := $(tc-getCXX)
cxx_gnu_libraries :=
cxx_gnu_optimization_options :=
	EOF

	cat >> build/import/libboost/configuration-dynamic.make <<- EOF
libboost_installed := y
	EOF

	cat >> build/import/libcult/configuration-dynamic.make <<- EOF
libcult_installed := y
	EOF
}

src_install() {
	find backend-elements -iname "*.cxx" \
		-o -iname "makefile" \
		-o -iname "*.o" -o -iname "*.d" \
		-o -iname "*.m4" -o -iname "*.l" \
		-o -iname "*.cpp-options" -o -iname "*.so" | xargs rm -f
	rm -rf backend-elements/arch

	insinto /usr/include
	doins -r backend-elements

	dodoc NEWS README
	dohtml -A xhtml -r documentation/*
}
