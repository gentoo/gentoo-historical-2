# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfcalendar/xfcalendar-4.2.3.ebuild,v 1.4 2006/04/15 01:49:51 halcy0n Exp $

inherit xfce42

DESCRIPTION="Xfce4 calendar"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

RDEPEND="|| ( ( x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM )
	virtual/x11 )
	~xfce-base/xfce4-panel-${PV}"

core_package
