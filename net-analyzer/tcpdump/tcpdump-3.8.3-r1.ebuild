# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.8.3-r1.ebuild,v 1.11 2004/05/26 20:26:43 vapier Exp $

inherit flag-o-matic gcc

DESCRIPTION="A Tool for network monitoring and data acquisition"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="mirror://sourceforge/tcpdump/${P}.tar.gz
	http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa ia64 amd64"
IUSE="ssl ipv6"

DEPEND=">=net-libs/libpcap-0.8.3-r1
	ssl? ( >=dev-libs/openssl-0.9.6m )"

src_compile() {
	replace-flags -O[3-9] -O2
	filter-flags -finline-functions
	[ "`gcc-fullversion`" == "3.4.0" ] && append-flags -fno-unit-at-a-time

	econf `use_with ssl crypto` `use_enable ipv6` || die
	make CCOPT="$CFLAGS" || die
}

src_install() {
	dosbin tcpdump || die
	doman tcpdump.1
	dodoc *.awk
	dodoc README FILES VERSION CHANGES
}
