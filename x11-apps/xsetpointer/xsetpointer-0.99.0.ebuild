# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xsetpointer/xsetpointer-0.99.0.ebuild,v 1.3 2005/08/24 01:01:09 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xsetpointer application"
KEYWORDS="~arm ~s390 ~sparc ~x86"
RDEPEND="x11-libs/libXi
	x11-libs/libX11"
DEPEND="${RDEPEND}"
