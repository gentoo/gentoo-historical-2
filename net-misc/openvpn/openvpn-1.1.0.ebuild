# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openvpn/openvpn-1.1.0.ebuild,v 1.6 2002/10/04 21:25:00 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="OpenVPN is a robust and highly flexible tunneling application"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/openvpn/${P}.tar.gz"
HOMEPAGE="http://openvpn.sourceforge.net/"
SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 sparc sparc64"

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

}
