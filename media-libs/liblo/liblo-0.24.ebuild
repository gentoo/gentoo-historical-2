# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblo/liblo-0.24.ebuild,v 1.2 2008/04/10 14:49:07 drac Exp $

DESCRIPTION="Lightweight OSC (Open Sound Control) implementation"
HOMEPAGE="http://plugin.org.uk/liblo"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="doc ipv6"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

src_compile() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"
	econf --disable-dependency-tracking $(use_enable ipv6)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO
}
