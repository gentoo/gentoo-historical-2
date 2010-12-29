# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xset/xset-1.2.1.ebuild,v 1.5 2010/12/29 22:15:59 maekke Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="X.Org xset application"

KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext
	x11-libs/libXfontcache
	x11-libs/libXxf86misc"
DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIGURE_OPTIONS="--with-xf86misc --with-fontcache"
	xorg-2_pkg_setup
}
