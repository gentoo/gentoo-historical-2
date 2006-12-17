# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xcb-util/xcb-util-0.1_p20061216.ebuild,v 1.2 2006/12/17 19:56:36 lu_zero Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X C-language Bindings sample implementations"
SRC_URI="http://dev.gentoo.org/~joshuabaergen/distfiles/${P}.tar.bz2"
LICENSE="X11"
KEYWORDS="~amd64 ~ppc"
RDEPEND="x11-libs/libxcb"
DEPEND="${RDEPEND}
	x11-proto/xproto"
