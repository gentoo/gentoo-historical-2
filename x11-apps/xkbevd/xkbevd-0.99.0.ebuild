# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbevd/xkbevd-0.99.0.ebuild,v 1.1 2005/08/08 06:28:11 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xkbevd application"
KEYWORDS="~x86"
RDEPEND="x11-libs/libxkbfile"
DEPEND="${RDEPEND}"
