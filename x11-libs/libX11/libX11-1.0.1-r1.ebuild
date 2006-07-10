# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libX11/libX11-1.0.1-r1.ebuild,v 1.9 2006/07/10 13:08:27 agriffis Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org X11 library"
RESTRICT="mirror"
KEYWORDS="alpha amd64 arm ~hppa ia64 mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
IUSE="ipv6"
RDEPEND="x11-libs/xtrans
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-proto/kbproto
	x11-proto/inputproto
	!>=x11-proto/xproto-7.0.6"
DEPEND="${RDEPEND}
	x11-proto/xf86bigfontproto
	x11-proto/bigreqsproto
	x11-proto/xextproto
	x11-proto/xcmiscproto
	>=x11-misc/util-macros-0.99.0_p20051007"

PATCHES="${FILESDIR}/${P}-setuid.diff"

CONFIGURE_OPTIONS="$(use_enable ipv6)"
# xorg really doesn't like xlocale disabled.
# $(use_enable nls xlocale)

src_install() {
	x-modular_src_install

	local ENVD="10libx11"
	echo "LDPATH=\"/usr/lib\"" > ${T}/${ENVD}
	doenvd ${T}/${ENVD}
}
