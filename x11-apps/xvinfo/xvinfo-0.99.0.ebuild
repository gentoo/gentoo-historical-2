# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xvinfo/xvinfo-0.99.0.ebuild,v 1.5 2005/10/19 03:00:45 geoman Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xvinfo application"
KEYWORDS="~arm ~mips ~ppc ~s390 ~sparc ~x86"
RDEPEND="x11-libs/libXv
	x11-libs/libX11"
DEPEND="${RDEPEND}"
