# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcp-agent/dhcp-agent-0.37.ebuild,v 1.10 2005/01/29 21:21:55 dragonheart Exp $

DESCRIPTION="dhcp-agent is a portable UNIX Dynamic Host Configuration suite"
HOMEPAGE="http://dhcp-agent.sourceforge.net/"
SRC_URI="mirror://sourceforge/dhcp-agent/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND=">=dev-libs/libdnet-1.4
		virtual/libpcap"

src_install() {
	emake DESTDIR=${D} install || die
	dodoc README THANKS TODO UPGRADING CAVEATS
}
