# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcp-agent/dhcp-agent-0.37.ebuild,v 1.7 2004/06/24 23:41:17 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="dhcp-agent is a portable UNIX Dynamic Host Configuration suite"
HOMEPAGE="http://dhcp-agent.sourceforge.net/"
SRC_URI="mirror://sourceforge/dhcp-agent/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~sparc"

DEPEND=">=dev-libs/libdnet-1.4
		>=net-libs/libpcap-0.7.1"

src_compile() {

	econf || die
	emake CFLAGS="${CFLAGS} -Wall -g" || die

}

src_install() {

	einstall || die

	dodoc README THANKS TODO UPGRADING CAVEATS

}


