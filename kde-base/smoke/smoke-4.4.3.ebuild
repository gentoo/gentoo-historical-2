# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smoke/smoke-4.4.3.ebuild,v 1.1 2010/05/03 21:46:34 alexxy Exp $

EAPI="3"

KMNAME="kdebindings"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Scripting Meta Object Kompiler Engine"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="akonadi kdevplatform okular +phonon qimageblitz qtmultimedia qscintilla qwt semantic-desktop"

COMMON_DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	akonadi? ( $(add_kdebase_dep kdepimlibs) )
	kdevplatform? ( dev-util/kdevplatform:4 )
	okular? ( $(add_kdebase_dep okular) )
	phonon? ( >=media-sound/phonon-4.3.80[xcb] )
	qimageblitz? ( >=kde-base/qimageblitz-0.0.4 )
	qscintilla? ( x11-libs/qscintilla )
	qwt? ( x11-libs/qwt:5 )
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

KMEXTRA="generator/"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable akonadi)
		$(cmake-utils_use_enable akonadi Kdepimlibs)
		$(cmake-utils_use_enable kdevplatform KDEVPLATFORM_SMOKE)
		$(cmake-utils_use_enable okular)
		$(cmake-utils_use_enable phonon PHONON_SMOKE)
		$(cmake-utils_use_enable qimageblitz QIMAGEBLITZ_SMOKE)
		$(cmake-utils_use_enable qscintilla QSCI_SMOKE)
		$(cmake-utils_use_enable qtmultimedia QTMULTIMEDIA_SMOKE)
		$(cmake-utils_use_enable qwt QWT_SMOKE)
		$(cmake-utils_use_enable semantic-desktop Nepomuk)
		$(cmake-utils_use_enable semantic-desktop Soprano)
		$(cmake-utils_use_enable webkit QTWEBKIT_SMOKE)
	)
	kde4-meta_src_configure
}
