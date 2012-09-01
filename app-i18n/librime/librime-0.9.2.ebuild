# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/librime/librime-0.9.2.ebuild,v 1.1 2012/09/01 10:42:58 yngwin Exp $

EAPI=4

inherit cmake-utils multilib vcs-snapshot

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://code.google.com/p/rimeime/"
SRC_URI="https://github.com/lotem/${PN}/tarball/rime-${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="app-i18n/opencc
	dev-cpp/glog
	dev-cpp/yaml-cpp
	dev-db/kyotocabinet
	>=dev-libs/boost-1.46.0
	sys-libs/zlib
	x11-proto/xproto"
DEPEND="${RDEPEND}"

src_prepare() {
	# patch the cmake system to make it disable data resource build
	epatch "${FILESDIR}"/${PN}-data-option.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC)
		-DBUILD_DATA=OFF
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

