# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xev/xev-1.0.2.ebuild,v 1.5 2006/09/10 09:06:03 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xev application"

KEYWORDS="alpha amd64 arm mips ppc ppc64 s390 sh sparc x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
