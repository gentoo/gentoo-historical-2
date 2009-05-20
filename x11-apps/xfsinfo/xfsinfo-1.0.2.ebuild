# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xfsinfo/xfsinfo-1.0.2.ebuild,v 1.6 2009/05/20 13:49:52 ranger Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X font server information utility"
KEYWORDS="amd64 ~mips ppc ppc64 ~sparc x86"
IUSE=""
RDEPEND="x11-libs/libX11
	x11-libs/libFS"
DEPEND="${RDEPEND}"
