# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/hashalot/hashalot-0.3.ebuild,v 1.10 2004/10/05 11:46:56 pvdabeel Exp $

DESCRIPTION="CryptoAPI utils"
HOMEPAGE="http://www.kerneli.org/"
SRC_URI="http://www.paranoiacs.org/~sluskyb/hacks/hashalot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc mips alpha ~arm amd64 ia64 hppa ppc"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="sys-apps/gawk
	sys-apps/grep
	virtual/libc
	sys-devel/gcc"

src_test() {
	make check-TESTS || die
}

src_install() {
	emake DESTDIR=${D} install || die "install error"
}
