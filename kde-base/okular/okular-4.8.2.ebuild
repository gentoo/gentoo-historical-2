# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/okular/okular-4.8.2.ebuild,v 1.1 2012/04/04 23:59:34 johu Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Okular is an universal document viewer based on KPDF for KDE 4."
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="chm crypt debug djvu ebook +jpeg +ps +pdf +tiff"

DEPEND="
	media-libs/freetype
	media-libs/qimageblitz
	sys-libs/zlib
	chm? ( dev-libs/chmlib )
	crypt? ( app-crypt/qca:2 )
	djvu? ( app-text/djvu )
	ebook? ( app-text/ebook-tools )
	jpeg? ( virtual/jpeg:0 )
	pdf? ( >=app-text/poppler-0.12.3-r3[lcms,qt4,-exceptions(-)] )
	ps? ( app-text/libspectre )
	tiff? ( media-libs/tiff )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with chm)
		$(cmake-utils_use_with crypt QCA2)
		$(cmake-utils_use_with djvu DjVuLibre)
		$(cmake-utils_use_with ebook EPub)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with ps LibSpectre)
		$(cmake-utils_use_with pdf PopplerQt4)
		$(cmake-utils_use_with pdf Poppler)
		$(cmake-utils_use_with tiff)
	)

	kde4-base_src_configure
}
