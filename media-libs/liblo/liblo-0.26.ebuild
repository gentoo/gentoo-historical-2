# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblo/liblo-0.26.ebuild,v 1.2 2009/06/10 19:35:14 maekke Exp $

EAPI=2

DESCRIPTION="Lightweight OSC (Open Sound Control) implementation"
HOMEPAGE="http://plugin.org.uk/liblo"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc ipv6"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"

	econf \
		--disable-dependency-tracking \
		$(use_enable ipv6)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
