# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXt/libXt-1.0.8.ebuild,v 1.6 2010/05/12 18:13:18 ranger Exp $

EAPI=3
inherit xorg-2 flag-o-matic toolchain-funcs

DESCRIPTION="X.Org Xt library"

KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libSM
	x11-proto/xproto
	x11-proto/kbproto"
DEPEND="${RDEPEND}"

pkg_setup() {
	xorg-2_pkg_setup
	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect

	if tc-is-cross-compiler; then
		export CFLAGS_FOR_BUILD="${BUILD_CFLAGS}"
	fi
}
