# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xev/xev-1.0.3.ebuild,v 1.7 2009/04/05 21:21:31 maekke Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="print contents of X events"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
