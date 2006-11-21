# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xvinfo/xvinfo-1.0.1.ebuild,v 1.5 2006/11/21 20:16:34 josejx Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Print out X-Video extension adaptor information"
KEYWORDS="~amd64 ~arm ~hppa ~mips ppc ~ppc64 ~s390 ~sparc ~x86"
RDEPEND="x11-libs/libXv
	x11-libs/libX11"
DEPEND="${RDEPEND}"
