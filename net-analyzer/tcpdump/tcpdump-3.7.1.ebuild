# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.7.1.ebuild,v 1.17 2004/05/02 07:20:05 vapier Exp $

IUSE="ssl ipv6"

S=${WORKDIR}/${P}
DESCRIPTION="A Tool for network monitoring and data acquisition"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	 http://www.jp.tcpdump.org/release/${P}.tar.gz"
HOMEPAGE="http://www.tcpdump.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha mips"

DEPEND=">=net-libs/libpcap-0.6.1
	ssl? ( >=dev-libs/openssl-0.6.9 )"


src_compile() {
	local myconf

	use ssl || myconf="--without-crypto"
	econf \
		--enable-ipv6 \
		${myconf} || die
	make CCOPT="$CFLAGS" || die
}

src_install() {
	into /usr
	dosbin tcpdump
	doman tcpdump.1
	dodoc *.awk
	dodoc README FILES VERSION CHANGES
}
