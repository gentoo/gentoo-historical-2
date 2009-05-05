# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/rgb/rgb-1.0.3.ebuild,v 1.9 2009/05/05 07:37:29 fauli Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="uncompile an rgb color-name database"

KEYWORDS="~alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}
	x11-proto/xproto"
