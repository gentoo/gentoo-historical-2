# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpv6/dhcpv6-1.0.19.ebuild,v 1.2 2008/07/02 01:08:03 darkside Exp $

inherit flag-o-matic

DESCRIPTION="Server and client for DHCPv6"
HOMEPAGE="https://fedorahosted.org/dhcpv6/"
SRC_URI="http://dcantrel.fedorapeople.org/dhcpv6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="static"

DEPEND="${RDEPEND}" #configure bails if libnl isn't present
RDEPEND=">=dev-libs/libnl-1.1"

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

mkd() {
	local x=$1 X=$2 i=$3
	sed \
		-e "s:6x:6${x}:g" \
		-e "s:6X:6${X}:g" \
		"${FILESDIR}"/dhcp6x.${i}d.in > dhcp6${x}.${i}d
	new${i}d dhcp6${x}.${i}d dhcp6${x}
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog README TODO RFC*
	dodir /var/lib/dhcpv6

	rm -rf "${D}"/etc/{rc.d,sysconfig}
	mkd s S init
	mkd s S conf
	mkd r R init
	mkd r R conf
}
