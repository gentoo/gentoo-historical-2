# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdca/libdca-0.0.5.ebuild,v 1.9 2007/07/28 16:11:54 drac Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils toolchain-funcs autotools

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/developers/libdca.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="oss debug"

RDEPEND="!media-libs/libdts"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-cflags.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable oss) $(use_enable debug) || die
	emake OPT_CFLAGS="" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO doc/${PN}.txt
}
