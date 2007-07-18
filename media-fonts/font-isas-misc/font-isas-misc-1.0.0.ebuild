# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-isas-misc/font-isas-misc-1.0.0.ebuild,v 1.13 2007/07/18 07:07:14 jer Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org the Institute of Software, Academia Sinica (chinese) fonts"
KEYWORDS="~alpha ~amd64 arm hppa ia64 ppc ppc64 s390 sh ~sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
