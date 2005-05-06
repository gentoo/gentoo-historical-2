# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.8.3-r2.ebuild,v 1.1 2005/05/06 22:16:12 vanquirius Exp $

inherit flag-o-matic gcc

DESCRIPTION="A Tool for network monitoring and data acquisition"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="mirror://sourceforge/tcpdump/${P}.tar.gz
	http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~ia64 ~amd64 ~ppc64"
IUSE="ssl ipv6"

DEPEND="virtual/libpcap
	ssl? ( >=dev-libs/openssl-0.9.6m )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PN}-3.8.3-gentoo.patch
}

src_compile() {
	replace-flags -O[3-9] -O2
	filter-flags -finline-functions

	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]; then
		filter-flags -funit-at-a-time
		append-flags -fno-unit-at-a-time #48747
	fi

	econf `use_with ssl crypto` `use_enable ipv6` || die
	make CCOPT="$CFLAGS" || die
}

src_install() {
	dosbin tcpdump || die
	doman tcpdump.1
	dodoc *.awk
	dodoc README FILES VERSION CHANGES
}
