# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-windowlist/xfce4-windowlist-0.1.0-r1.ebuild,v 1.7 2005/10/18 15:33:28 agriffis Exp $

DESCRIPTION="Xfce4 panel windowlist plugin"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"

GOODIES_PLUGIN=1
XFCE_S=${WORKDIR}/${MY_P/-${PV}/}

inherit xfce4
