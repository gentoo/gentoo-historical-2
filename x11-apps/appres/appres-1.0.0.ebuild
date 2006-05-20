# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/appres/appres-1.0.0.ebuild,v 1.5 2006/05/20 10:41:45 robbat2 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org appres application"
RESTRICT="mirror"
KEYWORDS="~amd64 ~arm ~mips ~ppc64 ~s390 ~sparc ~ppc ~x86"
RDEPEND="x11-libs/libX11
	x11-libs/libXt"
DEPEND="${RDEPEND}"
