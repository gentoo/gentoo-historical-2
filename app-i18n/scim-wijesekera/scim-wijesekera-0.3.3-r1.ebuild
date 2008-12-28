# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-wijesekera/scim-wijesekera-0.3.3-r1.ebuild,v 1.1 2008/12/28 16:19:24 matsuu Exp $

inherit autotools eutils

DESCRIPTION="Wijesekara keyboard for Sinhala input using scim"
HOMEPAGE="http://sinhala.sourceforge.net/"
SRC_URI="http://sinhala.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/scim-0.99.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README
}
