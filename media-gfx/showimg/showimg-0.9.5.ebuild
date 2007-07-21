# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/showimg/showimg-0.9.5.ebuild,v 1.10 2007/07/21 22:27:40 philantrop Exp $

inherit kde eutils

MY_PV="${PV/?.?.?.?/${PV%.*}-${PV##*.}}"
MY_P="${PN}-${MY_PV}"
MY_P=${P/_/-}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="ShowImg is a feature-rich image viewer for KDE  including an image management system."
HOMEPAGE="http://www.jalix.org/projects/showimg/"
#SRC_URI="http://www.jalix.org/projects/showimg/download/.0.9.5/distributions/SVN_info/${MY_P}.tar.bz2"
SRC_URI="http://www.jalix.org/projects/showimg/download/${MY_PV}/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="exif kipi mysql postgres"

DEPEND="|| ( kde-base/libkonq kde-base/kdebase )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/libpq dev-libs/libpqxx )
	exif? ( media-libs/libkexif )
	kipi? ( media-plugins/kipi-plugins )
	media-libs/libexif"
need-kde 3.4

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-as-needed.patch"
}

src_compile() {
	local myconf="--with-showimgdb \
		$(use_with exif kexif) \
		$(use_enable kipi libkipi) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql)"
	kde_src_compile all
}
