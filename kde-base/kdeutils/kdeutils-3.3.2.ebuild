# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.3.2.ebuild,v 1.5 2005/01/03 23:27:02 gmsoft Exp $

inherit kde-dist eutils

DESCRIPTION="KDE utilities"

KEYWORDS="x86 amd64 ~ppc64 ~sparc ~ppc hppa alpha"
IUSE=""

DEPEND="~kde-base/kdebase-${PV}
	app-crypt/gnupg"
