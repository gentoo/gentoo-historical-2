# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.3.0.ebuild,v 1.9 2005/01/23 20:06:29 corsair Exp $

inherit kde-dist eutils

DESCRIPTION="KDE utilities"

KEYWORDS="x86 amd64 ppc64 sparc ppc hppa"
IUSE=""

DEPEND="~kde-base/kdebase-${PV}
	app-crypt/gnupg"
