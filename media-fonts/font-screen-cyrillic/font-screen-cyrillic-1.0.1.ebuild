# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-screen-cyrillic/font-screen-cyrillic-1.0.1.ebuild,v 1.5 2007/12/19 23:40:47 cla Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Screen cyrillic fonts"
KEYWORDS="~amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
