# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/librime/librime-1.1.ebuild,v 1.1 2014/01/03 21:44:31 hwoarang Exp $

EAPI=5

inherit cmake-utils multilib versionator toolchain-funcs

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://code.google.com/p/rimeime/"
SRC_URI="http://rimeime.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RDEPEND="app-i18n/opencc
	dev-cpp/glog
	>=dev-cpp/yaml-cpp-0.5.0
	dev-db/kyotocabinet
	>=dev-libs/boost-1.46.0[threads(+)]
	sys-libs/zlib
	x11-proto/xproto"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}"

pkg_pretend() {
	if [ ${MERGE_TYPE} != binary ]; then
		version_is_at_least 4.8.0 "$(gcc-fullversion)" \
			|| die "Sorry, but gcc-4.8.0 and earlier wont work for librime (see bug 496080)."
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC)
		-DBUILD_DATA=OFF
		-DBUILD_SEPARATE_LIBS=OFF
		$(cmake-utils_use_build test TEST)
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
