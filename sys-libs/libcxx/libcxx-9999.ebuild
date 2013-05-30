# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-9999.ebuild,v 1.8 2013/05/30 23:36:35 aballier Exp $

EAPI=5

ESVN_REPO_URI="http://llvm.org/svn/llvm-project/libcxx/trunk"

[ "${PV%9999}" != "${PV}" ] && SCM="subversion" || SCM=""

inherit cmake-utils ${SCM} base flag-o-matic

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="static-libs"

RDEPEND=">=sys-libs/libcxxrt-0.0_p20130530[static-libs?]"
DEPEND="${RDEPEND}
	sys-devel/clang
	app-arch/xz-utils"

PATCHES=( "${FILESDIR}/multilib.patch"
		  "${FILESDIR}/cxxrt.patch" )
DOCS=( "CREDITS.TXT" )

src_prepare() {
	base_src_prepare
}

src_configure() {
	# Needs to be built with clang. gcc-4.6.3 fails at least.
	# TODO: cross-compile ?
	export CC=clang
	export CXX=clang++

	local mycmakeargs_base=(
		 -DLIBCXX_CXX_ABI=libcxxrt
		 -DLIBCXX_LIBCXXRT_INCLUDE_PATHS="/usr/include/libcxxrt/"
	)
	if use static-libs ; then
		local mycmakeargs=( "${mycmakeargs_base[@]}" "-DLIBCXX_ENABLE_SHARED=OFF" )
		BUILD_DIR="${S}_static"	cmake-utils_src_configure
	fi
	local mycmakeargs=( "${mycmakeargs_base[@]}" )
	BUILD_DIR="${S}_shared" cmake-utils_src_configure
}

src_compile() {
	use static-libs && BUILD_DIR="${S}_static" cmake-utils_src_compile
	BUILD_DIR="${S}_shared" cmake-utils_src_compile
}

# Tests fail for now, if anybody is able to fix them, help is very welcome.
src_test() {
	cd "${S}/test"
	LD_LIBRARY_PATH="${S}_shared/lib:${LD_LIBRARY_PATH}" \
		CC="clang++" \
		HEADER_INCLUDE="-I${S}/include" \
		SOURCE_LIB="-L${S}_shared/lib" \
		LIBS="-lm" \
		./testit || die
}

src_install() {
	use static-libs && BUILD_DIR="${S}_static" cmake-utils_src_install
	BUILD_DIR="${S}_shared" cmake-utils_src_install
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
