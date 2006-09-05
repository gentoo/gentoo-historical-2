# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xsetpointer/xsetpointer-1.0.0.ebuild,v 1.6 2006/09/05 23:03:14 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xsetpointer application"
RESTRICT="mirror"
KEYWORDS="alpha amd64 arm mips ppc ppc64 ~s390 sh sparc x86"
RDEPEND="x11-libs/libXi
	x11-libs/libX11"
DEPEND="${RDEPEND}"
