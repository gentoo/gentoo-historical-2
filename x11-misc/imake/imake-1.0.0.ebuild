# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/imake/imake-1.0.0.ebuild,v 1.1 2005/12/17 23:14:34 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org imake build system"
KEYWORDS="~amd64 ~mips ~sparc ~x86"
RDEPEND="x11-misc/xorg-cf-files"
DEPEND="${RDEPEND}
		x11-proto/xproto"

PATCHES=""
