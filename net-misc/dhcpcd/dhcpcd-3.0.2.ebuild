# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-3.0.2.ebuild,v 1.2 2006/12/04 10:06:04 uberlord Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A DHCP client only"
HOMEPAGE="http://dhcpcd.berlios.de"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
PROVIDE="virtual/dhcpc"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Compile against 2.6.19 linux headers
	epatch "${FILESDIR}/${P}-if_addr.patch"

	# Redefine the location of ntp.drift
	sed -i -e 's,#define NTPDRIFTFILE\t.*,#define NTPDRIFTFILE\t\t\"/var/lib/ntp/ntp.drift\",' \
		pathnames.h || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog
}
