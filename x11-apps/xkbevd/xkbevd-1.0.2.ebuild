# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbevd/xkbevd-1.0.2.ebuild,v 1.6 2008/09/11 17:44:26 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="XKB event daemon"
KEYWORDS="~amd64 arm ~mips ~ppc ~ppc64 s390 sh ~sparc x86"
RDEPEND="x11-libs/libxkbfile"
DEPEND="${RDEPEND}"
