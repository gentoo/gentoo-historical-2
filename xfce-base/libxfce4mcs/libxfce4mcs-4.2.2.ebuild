# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4mcs/libxfce4mcs-4.2.2.ebuild,v 1.3 2005/07/08 00:12:02 bcowan Exp $

DESCRIPTION="Libraries for Xfce 4"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"

RDEPEND="~xfce-base/libxfce4util-${PV}
	~xfce-base/libxfcegui4-${PV}"

inherit xfce4
