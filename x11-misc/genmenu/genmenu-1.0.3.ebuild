# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/genmenu/genmenu-1.0.3.ebuild,v 1.5 2004/04/27 20:41:44 agriffis Exp $

inherit eutils

IUSE=""

DESCRIPTION="menu generator for Blackbox, WindowMaker, and Enlightenment"
HOMEPAGE="http://projects.gtk.mine.nu/genmenu"
SRC_URI="http://projects.gtk.mine.nu/archive/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/glibc"
RDEPEND="app-shells/bash"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/genmenu-1.0.2.patch
}

src_install () {
	dobin genmenu

	# Install documentation.
	dodoc ChangeLog README
}
