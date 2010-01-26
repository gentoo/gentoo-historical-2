# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libisoburn/libisoburn-0.4.8.ebuild,v 1.1 2010/01/26 18:28:47 billie Exp $

EAPI=2

MY_PL=00
[[ ${PV/_p} != ${PV} ]] && MY_PL=${PV#*_p}
MY_PV="${PV%_p*}.pl${MY_PL}"

DESCRIPTION="Enables creation and expansion of ISO-9660 filesystems on all CD/DVD media supported by libburn"
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="acl external-filters external-filters-setuid readline xattr zlib"
#IUSE="acl cdio external-filters external-filters-setuid readline xattr zlib"
#Supports libcdio but needs version >=0.83 which is not yet released.

RDEPEND=">=dev-libs/libburn-0.7.6
	>=dev-libs/libisofs-0.6.26
	acl? ( virtual/acl )
	readline? ( sys-libs/readline )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
#RDEPEND="cdio? ( >=dev-libs/libcdio-0.83 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P%_p*}

src_configure() {
	econf --disable-static \
	--disable-dvd-obs-64k \
	--disable-libcdio \
	$(use_enable acl libacl) \
	$(use_enable external-filters) \
	$(use_enable external-filters-setuid) \
	$(use_enable readline libreadline) \
	$(use_enable xattr) \
	$(use_enable zlib)
#	$(use_enable cdio libcdio) \
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS CONTRIBUTORS README TODO doc/comments || die "dodoc failed"

	cd "${S}"/xorriso
	docinto xorriso
	dodoc changelog.txt README || die "dodoc failed"

	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}
