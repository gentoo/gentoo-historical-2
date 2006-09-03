# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-winitzki-cyrillic/font-winitzki-cyrillic-1.0.0.ebuild,v 1.8 2006/09/03 06:36:22 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular


DESCRIPTION="X.Org Winitzki cyrillic font"
RESTRICT="mirror"
KEYWORDS="~amd64 arm ~hppa ia64 ~ppc ppc64 s390 sh ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
