# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipv6calc/ipv6calc-0.73.0.ebuild,v 1.2 2009/10/24 18:38:02 klausman Exp $

inherit fixheadtails

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="http://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="geoip"

DEPEND="geoip? ( >=dev-libs/geoip-1.4.1 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	ht_fix_file configure
}

src_compile() {
	econf $(use_enable geoip)
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog CREDITS README TODO USAGE || die
}
