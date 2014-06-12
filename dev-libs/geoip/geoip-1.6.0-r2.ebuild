# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/geoip/geoip-1.6.0-r2.ebuild,v 1.1 2014/06/12 19:25:03 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="easily lookup countries by IP addresses, even when Reverse DNS entries don't exist"
HOMEPAGE="https://github.com/maxmind/geoip-api-c"
SRC_URI="
	https://github.com/maxmind/${PN}-api-c/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

# GPL-2 for md5.c - part of libGeoIPUpdate, MaxMind for GeoLite Country db
LICENSE="LGPL-2.1 GPL-2 MaxMind2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="city ipv6 static-libs"
RESTRICT="test"

DEPEND="net-misc/wget"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-api-c-${PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	dodoc AUTHORS ChangeLog README* TODO

	prune_libtool_files

	newsbin "${FILESDIR}"/geoipupdate-r3.sh geoipupdate.sh
}

pkg_postinst() {
	geoipupdate.sh --force
}

pkg_postrm() {
	rm -r "${ROOT}/usr/share/GeoIP/"
}
