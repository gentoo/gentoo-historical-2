# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-misc-meltho/font-misc-meltho-1.0.0.ebuild,v 1.3 2006/02/14 20:20:05 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

FONT_DIR="OTF"

inherit x-modular

DESCRIPTION="BigReqs prototype headers"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf
	>=media-fonts/font-util-0.99.2"

CONFIGURE_OPTIONS="--with-mapfiles=${XDIR}/share/fonts/util"
