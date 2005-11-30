# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-cpugraph/xfce4-cpugraph-0.2.2-r1.ebuild,v 1.1.1.1 2005/11/30 09:38:56 chriswhite Exp $

DESCRIPTION="Xfce4 panel cpu load graphing plugin"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"

XFCE_S=${WORKDIR}/${MY_P/-${PV}/}
GOODIES_PLUGIN=1

inherit xfce4
