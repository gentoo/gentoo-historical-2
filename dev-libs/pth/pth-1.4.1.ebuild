# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pth/pth-1.4.1.ebuild,v 1.2 2002/10/04 05:17:34 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU Portable Threads"
SRC_URI="ftp://ftp.gnu.org/gnu/pth/pth-1.4.1.tar.gz"
HOMEPAGE="http://www.gnu.org/software/pth/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ANNOUNCE AUTHORS COPYING ChangeLog NEWS README THANKS USERS
}
