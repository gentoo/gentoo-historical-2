# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/kbiff/kbiff-3.6.1.ebuild,v 1.7 2002/08/01 11:40:16 seemant Exp $

inherit kde-base || die

need-kde 3

DESCRIPTION="KDE new mail notification utility (biff)"
SRC_URI="http://devel-home.kde.org/~granroth/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.granroth.org/kbiff/"


LICENSE="GPL-2"
KEYWORDS="x86"

newdepend ">=kde-base/kdebase-3"
