# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/zisofs-tools/zisofs-tools-1.0.4-r1.ebuild,v 1.1 2003/01/15 18:39:11 vapier Exp $

DESCRIPTION="User utilities for zisofs"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/fs/zisofs/"
SRC_URI="http://www.kernel.org/pub/linux/utils/fs/zisofs/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="static"

DEPEND=">=sys-libs/zlib-1.1.4"

src_compile() {
	use static && export LDFLAGS="${LDFLAGS} -static"
	econf || die
	make || die
}

src_install() {
	make INSTALLROOT=${D} install || die
	dodoc CHANGES COPYING INSTALL README
}
