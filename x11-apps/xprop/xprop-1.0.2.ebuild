# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xprop/xprop-1.0.2.ebuild,v 1.3 2007/04/25 13:01:25 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="property displayer for X"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"
