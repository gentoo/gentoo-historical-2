# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/qtparted/qtparted-0.3.2.ebuild,v 1.1 2003/07/22 02:43:28 caleb Exp $

inherit kde
need-qt 3.1

DESCRIPTION="QtParted is a nice Qt partition tool for Linux"
HOMEPAGE="http://qtparted.sourceforge.net"
SRC_URI="mirror://sourceforge/qtparted/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND=">=x11-libs/qt-3.1.0
        >=sys-apps/parted-1.6.5
	>=dev-libs/progsreiserfs-0.3.0.3
	>=sys-apps/xfsprogs-2.3.9
	>=sys-apps/jfsutils-1.1.2
	>=sys-apps/ntfsprogs-1.7.1
	>=sys-apps/e2fsprogs-1.33"
