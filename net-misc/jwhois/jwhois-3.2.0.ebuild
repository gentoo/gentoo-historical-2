# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jwhois/jwhois-3.2.0.ebuild,v 1.12 2004/07/01 21:23:07 squinky86 Exp $

S=${WORKDIR}/${P}
IUSE=""
DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="http://www.gnu.org/software/jwhois/"
LICENSE="GPL-2"
KEYWORDS="x86 sparc mips"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://www.mirror.ac.uk/sites/ftp.gnu.org/gnu/jwhois/${P}.tar.gz
	ftp://ftp.gnu.org/gnu/jwhois/${P}.tar.gz"
SLOT="0"

DEPEND="virtual/libc"

src_compile() {
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--localstatedir=/var/cache/ \
		--without-cache \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}

