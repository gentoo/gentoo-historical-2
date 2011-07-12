# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libssh/libssh-0.5.0.ebuild,v 1.2 2011/07/12 21:16:09 maekke Exp $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="http://www.libssh.org/"
SRC_URI="http://www.${PN}.org/files/${PV:0:3}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="debug doc examples gcrypt pcap +sftp ssh1 server static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

RDEPEND="
	zlib? ( >=sys-libs/zlib-1.2 )
	!gcrypt? ( >=dev-libs/openssl-0.9.8 )
	gcrypt? ( >=dev-libs/libgcrypt-1.4 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-util/cmockery )
"

DOCS=( AUTHORS README ChangeLog )

src_prepare() {
	# just install the examples do not compile them
	sed -i \
		-e '/add_subdirectory(examples)/s/^/#DONOTWANT/' \
		CMakeLists.txt || die

	epatch "${FILESDIR}"/${P}-no-server.patch \
		"${FILESDIR}"/${P}-no-pdf-doc.patch \
		"${FILESDIR}"/${P}-tests.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with debug DEBUG_CALLTRACE)
		$(cmake-utils_use_with debug DEBUG_CRYPTO)
		$(cmake-utils_use_with gcrypt)
		$(cmake-utils_use_with pcap)
		$(cmake-utils_use_with server)
		$(cmake-utils_use_with sftp)
		$(cmake-utils_use_with ssh1)
		$(cmake-utils_use_with static-libs STATIC_LIB)
		$(cmake-utils_use_with test TESTING)
		$(cmake-utils_use_with zlib LIBZ)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install

	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/doc/html/*

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,cpp}
	fi
}
