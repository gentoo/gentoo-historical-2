# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kdiff3/kdiff3-0.9.80.ebuild,v 1.1 2003/12/17 13:14:31 caleb Exp $
inherit kde
need-kde 3

DESCRIPTION="KDE-based frontend to diff3"
SRC_URI="mirror://sourceforge/kdiff3/${P}.tar.gz"
HOMEPAGE="http://kdiff3.sourceforge.net/"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"

RDEPEND="$RDEPEND sys-apps/diffutils"
