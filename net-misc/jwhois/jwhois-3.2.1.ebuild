# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jwhois/jwhois-3.2.1.ebuild,v 1.6 2004/04/26 12:34:30 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="http://www.gnu.org/software/jwhois/"
LICENSE="GPL-2"
IUSE="nls"
KEYWORDS="x86 ~mips sparc"
SRC_URI="mirror://gentoo/${P}.tar.gz
	ftp://ftp.gnu.org/gnu/jwhois/${P}.tar.gz"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {
	local myconf

	use nls \
		&& myconf="--enable-nls" \
		|| myconf="--disable-nls"

	myconf="${myconf} --sysconfdir=/etc --localstatedir=/var/cache/ --without-cache"

	econf $myconf || die "econf failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
