# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pop3vscan/pop3vscan-0.4.ebuild,v 1.14 2004/07/15 01:52:10 agriffis Exp $

DESCRIPTION="A transparent POP3-Proxy with virus-scanning capabilities."
SRC_URI="mirror://sourceforge/pop3vscan/${P}.tar.gz"
HOMEPAGE="http://pop3vscan.sf.net/"

DEPEND="net-mail/ripmime dev-libs/libpcre"
RDEPEND="net-firewall/iptables"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"
IUSE=""

src_unpack() {
	unpack ${A}
	rm -f ${S}/ripmime/ripmime.a
}

src_compile() {
	make || die
}

src_install () {
	dodir /usr/sbin
	dosbin pop3vscan
	dodir /etc
	insinto /etc
	doins pop3vscan.conf pop3vscan.mail

	insinto /etc/init.d
	doins ${FILESDIR}/pop3vscan
	fperms 755 /etc/init.d/pop3vscan

	dodoc README
}

pkg_postinst() {
	useradd -d /tmp -s /bin/false -g nogroup mail
	dodir /var/spool/pop3vscan
	fowners mail /var/spool/pop3vscan
	fperms 700 /var/spool/pop3vscan

	einfo "You need configure /etc/pop3vscan and /etc/pop3vscan.mail"
	einfo "For start pop3vscan you can use /etc/init.d/pop3vscan start"
	einfo "You need port-redirecting, a rule like:"
	einfo "iptables -t nat -A PREROUTING -p tcp -i eth0 --dport pop3 -j REDIRECT --to 8110"
	einfo "is enough"
}
