# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ddclient/ddclient-3.6.3.ebuild,v 1.12 2005/04/06 15:50:00 seemant Exp $

inherit eutils

DESCRIPTION="A perl based client for dyndns"
HOMEPAGE="http://burry.ca:4141/ddclient/"
SRC_URI="http://members.rogers.com/ddclient/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-lang/perl"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/${PN}-gentoo.diff
	epatch ${FILESDIR}/${PN}-mss1.diff
}

src_install() {
	dosbin ddclient || die "dosbin"
	insinto /etc/ddclient
	doins sample-*
	dodoc README
	exeinto /etc/init.d
	newexe ${FILESDIR}/ddclient.rc6 ddclient
}
