# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libisofs/libisofs-0.6.28.ebuild,v 1.7 2010/06/07 10:57:39 angelos Exp $

EAPI=2

DESCRIPTION="libisofs is an open-source library for reading, mastering and writing optical discs."
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ppc64 x86"
IUSE="acl xattr zlib"

RDEPEND="acl? ( virtual/acl )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --disable-static \
	$(use_enable acl libacl) \
	$(use_enable xattr) \
	$(use_enable zlib)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS NEWS README Roadmap TODO || die "dodoc failed"

	cd "${S}"/doc
	dodoc checksums.txt susp_aaip_2_0.txt susp_aaip_isofs_names.txt Tutorial \
		zisofs_format.txt || die "dodoc failed"

	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}
