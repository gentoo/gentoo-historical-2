# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/okular/okular-4.6.5.ebuild,v 1.1 2011/07/09 15:14:18 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	kde_eclass="kde4-base"
else
	KMNAME="kdegraphics"
	kde_eclass="kde4-meta"
fi
inherit ${kde_eclass}

DESCRIPTION="Okular is an universal document viewer based on KPDF for KDE 4."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="chm crypt debug djvu ebook +jpeg +ps +pdf +tiff"

DEPEND="
	media-libs/freetype
	sys-libs/zlib
	chm? ( dev-libs/chmlib )
	crypt? ( app-crypt/qca:2 )
	djvu? ( app-text/djvu )
	ebook? ( app-text/ebook-tools )
	jpeg? ( virtual/jpeg:0 )
	pdf? ( >=app-text/poppler-0.12.3-r3[lcms,qt4,-exceptions] )
	ps? ( app-text/libspectre )
	tiff? ( media-libs/tiff )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libs/mobipocket"

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

	${kde_eclass}_src_configure
}

if [[ ${PV} != *9999 ]]; then
src_install() {
	kde4-meta_src_install

	# why, oh why?!
	rm "${ED}/usr/share/apps/cmake/modules/FindKSane.cmake" || die
}
fi
