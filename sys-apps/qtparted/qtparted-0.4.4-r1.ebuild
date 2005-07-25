# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/qtparted/qtparted-0.4.4-r1.ebuild,v 1.3 2005/07/25 18:58:13 caleb Exp $

inherit qt3

DESCRIPTION="nice Qt partition tool for Linux"
HOMEPAGE="http://qtparted.sourceforge.net/"
SRC_URI="mirror://sourceforge/qtparted/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="$(qt_min_version 3.1)
	>=sys-apps/parted-1.6.7
	x11-libs/gksu
	>=sys-fs/e2fsprogs-1.33
	>=sys-fs/xfsprogs-2.3.9
	>=sys-fs/jfsutils-1.1.2
	>=sys-fs/ntfsprogs-1.7.1"

myconf="--disable-reiserfs --enable-labels"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc doc/README doc/README.Debian doc/TODO.txt doc/BUGS doc/DEVELOPER-FAQ
}
