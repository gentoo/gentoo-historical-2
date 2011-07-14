# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libproxy/libproxy-0.4.6-r3.ebuild,v 1.3 2011/07/14 17:35:39 pacho Exp $

EAPI=3
PYTHON_DEPEND="python? 2:2.6"

inherit cmake-utils mono python

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="http://code.google.com/p/libproxy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gnome kde mono networkmanager perl python test vala"

# FIXME: Disable webkit support due problems like bug #366791
# FIXME: Also disable xulrunner support due bug #360893, will be readded
# in the future when only spidermonkey mozjs is provided.

RDEPEND="gnome? ( gnome-base/gconf:2 )
	kde? ( >=kde-base/kdelibs-4.4.5 )
	mono? ( dev-lang/mono )
	networkmanager? ( net-misc/networkmanager )
	perl? (	dev-lang/perl )
	vala? ( dev-lang/vala:0.10 )"
#	xulrunner? ( >=net-libs/xulrunner-1.9.1:1.9 )
#	webkit? ( net-libs/webkit-gtk:2 )
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-mozjs-link_directory.patch
		"${FILESDIR}"/${P}-flags-mixing.patch
		"${FILESDIR}"/${P}-backports.patch )

	# http://code.google.com/p/libproxy/source/detail?r=791
#	has_version ">=net-libs/xulrunner-2" && \
#		PATCHES+=( "${FILESDIR}"/${P}-xulrunner-2.patch )

	DOCS="AUTHORS ChangeLog NEWS README"

	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
			-DPERL_VENDORINSTALL=ON
			-DCMAKE_C_FLAGS="${CFLAGS}"
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
			$(cmake-utils_use_with gnome GNOME)
			$(cmake-utils_use_with kde KDE4)
			$(cmake-utils_use_with mono DOTNET)
			$(cmake-utils_use_with networkmanager NM)
			$(cmake-utils_use_with perl PERL)
			$(cmake-utils_use_with python PYTHON)
			$(cmake-utils_use_with vala VALA)
			-DWITH_WEBKIT=OFF
			-DWITH_MOZJS=OFF
			$(cmake-utils_use test BUILD_TESTING)
	)
			#$(cmake-utils_use_with webkit WEBKIT)
			#$(cmake-utils_use_with xulrunner MOZJS)
	cmake-utils_src_configure
}

pkg_postinst() {
	use python && python_mod_optimize ${PN}.py
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}.py
}
