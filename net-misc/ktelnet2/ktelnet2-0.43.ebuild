# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/ktelnet2/ktelnet2-0.43.ebuild,v 1.6 2002/07/11 06:30:48 drobbins Exp $

inherit kde-base || die

need-kde 2.1.1

DESCRIPTION="A Putty like for KDE"
SRC_URI="http://www.spaghetti-code.de/download/ktelnet/${P}.tgz"
HOMEPAGE="http://www.spaghetti-code.de/software/linux/ktelnet/"
KEYWORDS="x86"
LICENSE="GPL-2"
