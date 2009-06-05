# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/showfont/showfont-1.0.2.ebuild,v 1.7 2009/06/05 17:01:32 tcunha Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="font dumper for X font server"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""
RDEPEND="x11-libs/libFS"
DEPEND="${RDEPEND}"
