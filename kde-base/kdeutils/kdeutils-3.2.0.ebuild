# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.2.0.ebuild,v 1.2 2004/02/05 16:45:25 lu_zero Exp $
inherit kde-dist

IUSE=""
DESCRIPTION="KDE utilities"

KEYWORDS="~x86 ~sparc ~amd64 ~ppc"

DEPEND="~kde-base/kdebase-${PV}
	app-crypt/gnupg
	!app-crypt/kgpg"
RDEPEND="$DEPEND"
