# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libX11/libX11-1.1.3.ebuild,v 1.3 2007/12/13 13:22:46 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org X11 library"

KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~x86-fbsd"
IUSE="ipv6 xcb"
RDEPEND=">=x11-libs/xtrans-1.0.1
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-proto/kbproto
	>=x11-proto/xproto-7.0.6
	xcb? ( >=x11-libs/libxcb-1.0 )"
DEPEND="${RDEPEND}
	x11-proto/xf86bigfontproto
	x11-proto/bigreqsproto
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xcmiscproto
	>=x11-misc/util-macros-0.99.0_p20051007"

CONFIGURE_OPTIONS="$(use_enable ipv6)
	$(use_with xcb)"
# xorg really doesn't like xlocale disabled.
# $(use_enable nls xlocale)
