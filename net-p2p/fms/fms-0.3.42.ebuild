# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/fms/fms-0.3.42.ebuild,v 1.1 2009/09/01 16:06:07 tommy Exp $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="A spam-resistant message board application for Freenet"
HOMEPAGE="http://freenetproject.org/tools.html"
SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="frost"

DEPEND="virtual/libiconv
	frost? ( >=dev-libs/libtomcrypt-1.17-r3[libtommath] )
	>=dev-libs/poco-1.2.9
	|| ( >=dev-db/sqlite-3.6.15 =dev-db/sqlite-3.6.13* =dev-db/sqlite-3.6.12* =dev-db/sqlite-3.6.11* =dev-db/sqlite-3.6.6.2* )"
RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-use-system-libs.patch
	sed -i "s:LTC_PKCS:LTC_LTC_PKCS:g" src/freenet/frostidentity.cpp
}

src_configure() {
	local mycmakeargs="-DI_HAVE_READ_THE_README=ON \
		-DUSE_BUNDLED_SQLITE=OFF \
		-DDO_CHARSET_CONVERSION=ON \
		$(cmake-utils_use frost FROST_SUPPORT)"
	use frost && append-flags -DLTM_DESC
	cmake-utils_src_configure
}

src_install() {
	insinto /var/freenet/fms
	dobin "${CMAKE_BUILD_DIR}"/fms || die
	doins {forum-,}template.htm || die "doinstall failed"
	insinto /var/freenet/fms/fonts
	doins fonts/*.bmp || die "doinstall of fonts failed"
	insinto /var/freenet/fms/images
	doins images/*png || die "doinstall of images failed"
	fperms -R o-rwx /var/freenet/fms/ /usr/bin/fms
	fowners -R freenet:freenet /var/freenet/fms/ /usr/bin/fms
	doinitd "${FILESDIR}/fms" || die "installing init.d file failed"
	dodoc readme.txt || die "installing doc failed"
}

pkg_postinst() {
	if ! has_version 'net-p2p/freenet' ; then
		ewarn "FMS needs a freenet node to up-/download #ssages."
		ewarn "Please make sure to have a node you can connect to"
		ewarn "or install net-p2p/freenet to get FMS working."
	fi
	elog "By default, the FMS NNTP server will listen on port 1119,"
	elog "and the web configuration interface will be running at"
	elog "http://localhost:8080. For more information, read"
	elog "${ROOT}usr/share/doc/${PF}/readme.txt.bz2"
	if use frost; then
		elog " "
		elog "You need to enable frost on the config page"
		elog "and restart fms for frost support."
	fi
}
