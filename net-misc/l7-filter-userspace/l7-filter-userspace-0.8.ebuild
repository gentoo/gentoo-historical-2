# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/l7-filter-userspace/l7-filter-userspace-0.8.ebuild,v 1.2 2008/11/15 21:11:15 pva Exp $

inherit eutils

DESCRIPTION="Userspace utilities for layer 7 iptables QoS"
HOMEPAGE="http://l7-filter.sourceforge.net"
SRC_URI="mirror://sourceforge/l7-filter/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
DEPEND="
		net-libs/libnetfilter_conntrack
		net-libs/libnetfilter_queue"
RDEPEND="net-misc/l7-protocols
		${DEPEND}"

src_unpack() {
	unpack ${A}
	cd"${S}"
	epatch "${FILESDIR}/l7-filter-userspace-in-fix.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TODO BUGS THANKS AUTHORS
}
