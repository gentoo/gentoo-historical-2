# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/basket/basket-1.80.ebuild,v 1.1 2010/04/22 17:38:12 spatz Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="A DropDrawers clone. Multiple information organizer"
HOMEPAGE="http://basket.kde.org/"
SRC_URI="http://${PN}.kde.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"

IUSE="debug crypt"

DEPEND="
	>=kde-base/kdelibs-4.4.0
	>=kde-base/kdepimlibs-4.4.0
	kde-base/qimageblitz
	crypt? ( >=app-crypt/gpgme-1.0 )
"
RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}/${P}-crypt.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable crypt)
	)
	kde4-base_src_configure
}
