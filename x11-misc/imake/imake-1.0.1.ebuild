# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/imake/imake-1.0.1.ebuild,v 1.5 2006/02/14 22:51:18 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org imake build system"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RDEPEND="x11-misc/xorg-cf-files
	!x11-misc/xmkmf"
DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=""
