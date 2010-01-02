# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smoke/smoke-4.3.3.ebuild,v 1.6 2010/01/02 21:09:44 yngwin Exp $

EAPI="2"

KMNAME="kdebindings"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Scripting Meta Object Kompiler Engine"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="akonadi kdevplatform +phonon qscintilla qwt +semantic-desktop"
# okular

COMMON_DEPEND="
	>=kde-base/qimageblitz-0.0.4
	akonadi? (
		app-office/akonadi-server
		$(add_kdebase_dep kdepimlibs)
	)
	kdevplatform? ( dev-util/kdevplatform:4 )
	phonon? ( >=media-sound/phonon-4.3.49[xcb] )
	qscintilla? ( x11-libs/qscintilla )
	qwt? ( x11-libs/qwt:5 )
	semantic-desktop? (
		dev-libs/soprano
		$(add_kdebase_dep nepomuk)
	)
"
# okular? ( kde-base/okular)  -- it can't find it anyway

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
"
RDEPEND="${COMMON_DEPEND}"

KMEXTRACTONLY="kalyptus/"

PATCHES=( "${FILESDIR}"/${PN}-phonon-fix.patch )

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable webkit QTWEBKIT_SMOKE)
		$(cmake-utils_use_enable qwt QWT_SMOKE)
		$(cmake-utils_use_enable qscintilla QSCI_SMOKE)
		$(cmake-utils_use_enable phonon PHONON_SMOKE)
		$(cmake-utils_use_enable kdevplatform KDEVPLATFORM_SMOKE)
		$(cmake-utils_use_enable semantic-desktop Nepomuk)
		$(cmake-utils_use_enable semantic-desktop Soprano)
		$(cmake-utils_use_enable akonadi Kdepimlibs)
		$(cmake-utils_use_enable akonadi)
		-DENABLE_Okular=OFF
	"
		# $(cmake-utils_use_enable okular)
	kde4-meta_src_configure
}
