# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXcomposite/libXcomposite-0.4.2.ebuild,v 1.9 2010/10/21 01:15:22 ranger Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org Xcomposite library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXext
	>=x11-proto/compositeproto-0.4
	x11-proto/xproto"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto )"

src_configure() {
	CONFIGURE_OPTIONS="$(use_with doc xmlto)"
	xorg-2_src_configure
}
