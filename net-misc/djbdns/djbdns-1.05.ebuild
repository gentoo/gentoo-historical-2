# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/djbdns/djbdns-1.05.ebuild,v 1.2 2001/05/28 05:24:13 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Excellent high-performance DNS services"
SRC_URI="http://cr.yp.to/djbdns/${A}"
HOMEPAGE="http://cr.yp.to/djbdns.html"

DEPEND="virtual/glibc"
RDEPEND="virtual/glibc >=sys-apps/daemontools-0.70"

src_unpack() {
	unpack ${A}
	cd ${S}
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	echo "/usr" > conf-home
}

src_compile() {                           
	cd ${S}
	try pmake
}

src_install() {                               
	cd ${S}
	into /usr
	for i in *-conf dnscache tinydns walldns rbldns pickdns axfrdns *-get *-data *-edit dnsip dnsipq dnsname dnstxt dnsmx dnsfilter random-ip dnsqr dnsq dnstrace dnstracesort
	do
		dobin $i
	done
	insinto /etc
	doins dnsroots.global
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/svc-dnscache
}
