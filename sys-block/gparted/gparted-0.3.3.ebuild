# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/gparted/gparted-0.3.3.ebuild,v 1.1 2007/01/17 21:29:00 blubb Exp $

inherit gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"

SRC_URI="mirror://sourceforge/gparted/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="fat hfs jfs ntfs reiserfs reiser4 xfs"

RDEPEND=">=sys-apps/parted-1.7.1
		>=dev-cpp/gtkmm-2.8.0
		fat? ( sys-fs/dosfstools )
		ntfs? ( sys-fs/ntfsprogs )
		hfs? ( sys-fs/hfsutils )
		jfs? ( sys-fs/jfsutils )
		reiserfs? ( sys-fs/reiserfsprogs )
		reiser4? ( sys-fs/reiser4progs )
		xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )"

DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.12
		>=dev-util/intltool-0.29"
