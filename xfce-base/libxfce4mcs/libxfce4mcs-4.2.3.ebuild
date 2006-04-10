# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4mcs/libxfce4mcs-4.2.3.ebuild,v 1.3 2006/04/10 19:53:26 gustavoz Exp $

inherit xfce42

DESCRIPTION="Libraries for Xfce 4"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86"

RDEPEND="|| ( ( x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM )
	virtual/x11 )
	=xfce-base/libxfce4util-4.2.3.2
	~xfce-base/libxfcegui4-${PV}"
DEPEND="${RDEPEND}
	|| ( ( x11-libs/libXt
	x11-proto/xproto )
	virtual/x11 )"

core_package
