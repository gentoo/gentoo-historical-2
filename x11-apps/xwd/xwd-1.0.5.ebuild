# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xwd/xwd-1.0.5.ebuild,v 1.3 2012/03/18 03:58:50 chithanh Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="dump an image of an X window"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

# libXt dependency is not in configure.ac, bug #408629, upstream #47462."
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-libs/libxkbfile
	x11-proto/xproto"
