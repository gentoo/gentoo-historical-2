# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-3.0.0.ebuild,v 1.1 2006/11/27 21:18:26 uberlord Exp $

inherit eutils

DESCRIPTION="A DHCP client only"
HOMEPAGE="http://developer.berlios.de/projects/dhcpcd/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
PROVIDE="virtual/dhcpc"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Redefine the location of ntp.drift
	sed -i -e 's,#define NTPDRIFTFILE .*,#define NTPDRIFTFILE \"/var/lib/ntp/ntp.drift\",' \
		pathnames.h || die "sed failed"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
}
