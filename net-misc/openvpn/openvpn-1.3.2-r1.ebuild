# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openvpn/openvpn-1.3.2-r1.ebuild,v 1.7 2004/08/25 02:52:16 swegener Exp $

IUSE="ssl"

DESCRIPTION="OpenVPN is a robust and highly flexible tunneling application"
SRC_URI="mirror://sourceforge/openvpn/${P}.tar.gz"
HOMEPAGE="http://openvpn.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

DEPEND=">=dev-libs/lzo-1.07
		virtual/linux-sources
		ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {

	local myconf

	use ssl || myconf='--disable-ssl --disable-crypto'

	./autogen.sh || die
	econf || die
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	dodoc COPYING CHANGES INSTALL PORTS README
	insinto /etc/init.d ; doins ${FILESDIR}/openvpn
	chmod 755 ${D}/etc/init.d/openvpn

}
