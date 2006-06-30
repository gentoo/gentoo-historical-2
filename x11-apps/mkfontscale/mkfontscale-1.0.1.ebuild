# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mkfontscale/mkfontscale-1.0.1.ebuild,v 1.10 2006/06/30 14:52:13 wolf31o2 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org mkfontscale application"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
RDEPEND="x11-libs/libfontenc
	x11-libs/libX11
	=media-libs/freetype-2*"
DEPEND="${RDEPEND}"
