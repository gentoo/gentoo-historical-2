# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pth/pth-1.4.0.ebuild,v 1.19 2004/10/10 18:10:07 usata Exp $

inherit gnuconfig libtool

DESCRIPTION="GNU Portable Threads"
HOMEPAGE="http://www.gnu.org/software/pth/"
SRC_URI="ftp://ftp.gnu.org/gnu/pth/pth-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 hppa ppc-macos"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	gnuconfig_update
	use ppc-macos && darwintoolize
}

src_install() {
	einstall || die
	dodoc ANNOUNCE AUTHORS ChangeLog NEWS README THANKS USERS
}
