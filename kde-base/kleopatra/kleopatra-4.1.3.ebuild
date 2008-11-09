# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kleopatra/kleopatra-4.1.3.ebuild,v 1.1 2008/11/09 02:00:03 scarabeus Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="Kleopatra - KDE X.509 key manager"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="app-crypt/gnupg
	app-crypt/gpgme
	dev-libs/libassuan
	>=kde-base/libkleo-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

#RESTRICT="test"

KMEXTRACTONLY="libkleo"
KMLOADLIBS="libkleo"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_QGpgme=ON"

	kde4-meta_src_configure
}
