# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-0.8.1-r1.ebuild,v 1.5 2004/07/01 22:26:27 eradicator Exp $

inherit eutils

DESCRIPTION="pcap-Library"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc sparc ~alpha ~mips hppa ~amd64 ~ia64"
IUSE="ipv6"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-fPIC.patch
}

src_compile() {
	econf `use_enable ipv6` || die "bad configure"
	emake || die "compile problem"

	# no provision for this in the Makefile, so...
	gcc -Wl,-soname,libpcap.so.0 -shared -fPIC -o libpcap.so.0.8 *.o
	assert "couldn't make a shared lib"
}

src_install() {
	einstall || die

	insopts -m 755
	insinto /usr/lib ; doins libpcap.so.0.8
	dosym /usr/lib/libpcap.so.0.8 /usr/lib/libpcap.so.0
	dosym /usr/lib/libpcap.so.0.8 /usr/lib/libpcap.so
	into /usr/include/net
	dosym /usr/include/pcap-bpf.h /usr/include/net/bpf.h

	dodoc CREDITS CHANGES FILES README* VERSION
}
