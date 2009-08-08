# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmtp/libmtp-1.0.0.ebuild,v 1.1 2009/08/08 06:11:06 ken69267 Exp $

EAPI=2
DESCRIPTION="An implementation of Microsoft's Media Transfer Protocol (MTP)."
HOMEPAGE="http://libmtp.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples static-libs"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	sys-apps/findutils"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm -f $(find "${D}" -name '*.la')
	dodoc AUTHORS ChangeLog README TODO || die "dodoc failed"

	insinto /etc/udev/rules.d
	newins libmtp.rules 65-mtp.rules

	insinto /usr/share/hal/fdi/information/20thirdparty
	newins libmtp.fdi 10-libmtp.fdi

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,sh}
	fi
}
