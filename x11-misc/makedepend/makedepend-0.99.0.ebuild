# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/makedepend/makedepend-0.99.0.ebuild,v 1.1 2005/08/08 05:08:06 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org makedepend utility"
KEYWORDS="~x86"
RDEPEND=""
DEPEND="${RDEPEND}
	x11-proto/xproto"
