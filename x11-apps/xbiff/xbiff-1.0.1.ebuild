# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xbiff/xbiff-1.0.1.ebuild,v 1.2 2006/02/14 20:58:51 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xbiff application"
KEYWORDS="~arm ~mips ~ppc64 ~s390 ~sparc ~x86"
IUSE="xprint"
RDEPEND="x11-libs/libXaw
	x11-misc/xbitmaps"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"
