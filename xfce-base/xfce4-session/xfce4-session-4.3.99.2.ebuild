# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-session/xfce4-session-4.3.99.2.ebuild,v 1.1 2006/12/05 17:04:43 nichoj Exp $

inherit xfce44

xfce44_beta

DESCRIPTION="Xfce 4 session manager"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="|| ( ( x11-libs/libX11
		x11-libs/libSM )
		virtual/x11 )
		~xfce-base/xfce-utils-${PV}"
DEPEND="${RDEPEND}
		|| ( x11-libs/libXt virtual/x11 )"

xfce44_core_package
