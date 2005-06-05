# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/kbiff/kbiff-3.7.1.ebuild,v 1.7 2005/06/05 11:51:22 hansmi Exp $

inherit kde eutils

DESCRIPTION="KDE new mail notification utility (biff)"
HOMEPAGE="http://www.granroth.org/kbiff/"
SRC_URI="http://devel-home.kde.org/~granroth/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="|| ( kde-base/kdebase-meta >=kde-base/kdebase-3 )"
need-kde 3

src_unpack() {
	kde_src_unpack

	use arts || epatch ${FILESDIR}/${P}-configure-arts.patch
}
