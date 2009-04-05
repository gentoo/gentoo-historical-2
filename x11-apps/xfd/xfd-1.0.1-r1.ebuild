# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xfd/xfd-1.0.1-r1.ebuild,v 1.3 2009/04/05 20:38:56 maekke Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xfd application"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""
RDEPEND="=media-libs/freetype-2*
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/libXaw"
DEPEND="${RDEPEND}"
