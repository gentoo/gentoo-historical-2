# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/firewalk/firewalk-5.0.ebuild,v 1.5 2005/01/29 05:12:51 dragonheart Exp $

DESCRIPTION="A tool for determining a firewall's rule set"
SRC_URI="http://www.packetfactory.net/firewalk/dist/${P}.tgz"
HOMEPAGE="http://www.packetfactory.net/firewalk/"
IUSE=""

S=${WORKDIR}/Firewalk

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/libpcap
	>=net-libs/libnet-1.1.1
	>=dev-libs/libdnet-1.7"

src_compile() {
	cd ${S}
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR=${D} || "emake install failed"
	doman man/firewalk.8
	dodoc README TODO BUGS
}
