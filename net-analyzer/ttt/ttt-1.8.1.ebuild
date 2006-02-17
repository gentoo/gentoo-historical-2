# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ttt/ttt-1.8.1.ebuild,v 1.4 2006/02/17 16:50:14 jokey Exp $

inherit eutils

DESCRIPTION="Tele Traffic Taper (ttt) - Real-time Graphical Remote Traffic Monitor"
SRC_URI="ftp://ftp.csl.sony.co.jp/pub/kjc/${P}.tar.gz"
HOMEPAGE="http://www.csl.sony.co.jp/person/kjc/kjc/software.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~ppc x86"
IUSE="ipv6"

DEPEND="virtual/libc
	|| ( ( x11-libs/libXt x11-proto/xproto ) virtual/x11 )
	dev-lang/tcl
	dev-lang/tk
	>=dev-tcltk/blt-2.4
	net-libs/libpcap"

src_unpack() {
	unpack ${A}
	cd ${S}
	grep 'pcap_lookupnet.*const' /usr/include/pcap.h &>/dev/null && \
		epatch ${FILESDIR}/${PN}-1.8-pcap.patch

	epatch ${FILESDIR}/${PN}-1.8-linux-sll.patch

	epatch ${FILESDIR}/${PN}-gcc4.diff
	# remove -Wwrite-strings -fwritable-strings (naughty)
	sed -i 's/\(GCCFLAGS="\).*\("\)/\1-Wall\2/' configure || die "sed failed"
}

src_compile() {
	local myconf
	use ipv6 && myconf="${myconf} --enable-ipv6"

	econf ${myconf} || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	dodoc README
	dodir /usr/bin
	dodir /usr/lib/ttt
	dodir /usr/share/man/man1
	einstall exec_prefix=${D}/usr install-man || die "make install failed"
	prepall
}
