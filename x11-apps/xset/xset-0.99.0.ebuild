# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xset/xset-0.99.0.ebuild,v 1.1 2005/08/08 06:28:12 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xset application"
KEYWORDS="~x86"
RDEPEND="x11-libs/libXmu"
DEPEND="${RDEPEND}"
