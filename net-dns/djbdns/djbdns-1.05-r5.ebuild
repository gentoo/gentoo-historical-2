# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/djbdns/djbdns-1.05-r5.ebuild,v 1.1 2002/11/18 06:07:37 jhhudso Exp $

DESCRIPTION="Excellent high-performance DNS services"
SRC_URI="http://cr.yp.to/djbdns/${P}.tar.gz
	http://www.skarnet.org/software/djbdns-fwdzone/djbdns-1.04-fwdzone.patch
	mirror://${P}-ipv6-gentoo.diff.bz2"
HOMEPAGE="http://cr.yp.to/djbdns.html"
LICENSE="as-is"
KEYWORDS="~x86 ~sparc ~sparc64"
SLOT="0"
IUSE="ipv6"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}
	>=sys-apps/daemontools-0.70
	sys-apps/ucspi-tcp"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${P}.tar.gz
	patch -d ${S} -p1 < ${DISTDIR}/djbdns-1.04-fwdzone.patch
	if [ `use ipv6` ] ; then
		bunzip2 -dc ${DISTDIR}/djbdns-1.05-ipv6-gentoo.diff.bz2 |
		patch -d ${S} -p1 || die "Failed to apply the ipv6 patch"
	fi
}

src_compile() {                           
	LDFLAGS=
	use static && LDFLAGS="-static"
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc ${LDFLAGS}" > conf-ld
	echo "/usr" > conf-home
	emake || die "emake failed"
}

src_install() {                               
	insinto /etc
	doins dnsroots.global
	into /usr
	for i in *-conf dnscache tinydns walldns rbldns pickdns axfrdns *-get *-data *-edit dnsip dnsipq dnsname dnstxt dnsmx dnsfilter random-ip dnsqr dnsq dnstrace dnstracesort
	do
		dobin $i
	done
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION

	dobin ${FILESDIR}/dnscache-setup
	dobin ${FILESDIR}/tinydns-setup
}

pkg_postinst() {
	groupadd &>/dev/null nofiles
	id &>/dev/null dnscache || \
		useradd -g nofiles -d /nonexistent -s /bin/false dnscache
	id &>/dev/null dnslog || \
		useradd -g nofiles -d /nonexistent -s /bin/false dnslog
	id &>/dev/null tinydns || \
		useradd -g nofiles -d /nonexistent -s /bin/false tinydns

	einfo "Use dnscache-setup and tinydns-setup to help you configure your nameservers!"
}
