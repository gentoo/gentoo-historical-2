# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/twm/twm-1.0.1.ebuild,v 1.7 2006/03/31 20:11:07 flameeyes Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org twm application"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu"
DEPEND="${RDEPEND}"
