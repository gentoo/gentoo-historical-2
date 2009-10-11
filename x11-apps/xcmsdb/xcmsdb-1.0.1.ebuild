# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xcmsdb/xcmsdb-1.0.1.ebuild,v 1.15 2009/10/11 11:06:50 nixnut Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Device Color Characterization utility for X Color Management System"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
