# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-screen-cyrillic/font-screen-cyrillic-0.99.1.ebuild,v 1.1 2005/12/07 11:32:55 spyderous Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular


DESCRIPTION="BigReqs prototype headers"
KEYWORDS="~amd64 ~arm ~ia64 ~s390 ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/mkfontdir
	x11-apps/mkfontscale
	x11-apps/bdftopcf"
