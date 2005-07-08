# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfcegui4/libxfcegui4-4.2.2.ebuild,v 1.5 2005/07/08 17:24:33 gustavoz Exp $

DESCRIPTION="Libraries for Xfce 4"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="~xfce-base/libxfce4util-${PV}"

inherit xfce4
