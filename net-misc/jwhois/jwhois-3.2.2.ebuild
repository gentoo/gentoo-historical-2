# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jwhois/jwhois-3.2.2.ebuild,v 1.12 2004/06/25 03:12:38 agriffis Exp $

DESCRIPTION="Advanced Internet Whois client capable of recursive queries"
HOMEPAGE="http://www.gnu.org/software/jwhois/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha arm hppa amd64 ia64"
IUSE="nls"

DEPEND="virtual/glibc"

src_compile() {
	econf \
		--localstatedir=/var/cache \
		--without-cache \
		`use_enable nls` \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
