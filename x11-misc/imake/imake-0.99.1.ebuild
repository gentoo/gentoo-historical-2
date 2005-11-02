# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/imake/imake-0.99.1.ebuild,v 1.3 2005/11/02 19:33:44 fmccor Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org imake build system"
KEYWORDS="~amd64 ~sparc ~x86"
RDEPEND="x11-misc/xorg-cf-files"
DEPEND="${RDEPEND}
		x11-proto/xproto"

PATCHES=""
