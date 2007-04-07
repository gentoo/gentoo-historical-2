# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tinc/tinc-1.0.5.ebuild,v 1.2 2007/04/07 13:38:28 opfer Exp $

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="http://www.tinc-vpn.org/"
SRC_URI="http://www.tinc-vpn.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="nls"

DEPEND=">=dev-libs/openssl-0.9.7c
	virtual/linux-sources
	>=dev-libs/lzo-2
	>=sys-libs/zlib-1.1.4-r2
	nls? ( sys-devel/gettext )"

src_compile() {
	econf --enable-jumbograms $(use_enable nls) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README THANKS TODO
	exeinto /etc/init.d ; newexe ${FILESDIR}/tincd tincd
}

pkg_postinst() {
	einfo "This package requires the tun/tap kernel device."
	einfo "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}
