# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/iceauth/iceauth-1.0.1.ebuild,v 1.4 2006/02/14 20:36:28 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org iceauth application"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RDEPEND="x11-libs/libX11
	x11-libs/libICE"
DEPEND="${RDEPEND}"
