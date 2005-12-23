# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xlogo/xlogo-1.0.1.ebuild,v 1.1 2005/12/23 10:42:30 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xlogo application"
KEYWORDS="~amd64 ~arm ~mips ~s390 ~sparc ~x86"
# Broken without xprint
#IUSE="xprint"
RDEPEND="x11-libs/libXrender
	x11-libs/libXaw
	x11-libs/libXprintUtil"
#	xprint? ( x11-libs/libXprintUtil )"
DEPEND="${RDEPEND}"

#CONFIGURE_OPTIONS="$(use_enable xprint)"
