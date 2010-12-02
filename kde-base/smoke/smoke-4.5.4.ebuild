# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smoke/smoke-4.5.4.ebuild,v 1.1 2010/12/02 21:15:47 alexxy Exp $

EAPI="3"

KMNAME="kdebindings"
MULTIMEDIA_REQUIRED="optional"
QTHELP_REQUIRED="optional"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Scripting Meta Object Kompiler Engine"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="akonadi attica debug okular +phonon qimageblitz qscintilla qwt semantic-desktop"

COMMON_DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	akonadi? ( $(add_kdebase_dep kdepimlibs) )
	attica? ( dev-libs/libattica )
	okular? ( $(add_kdebase_dep okular) )
	phonon? ( >=media-sound/phonon-4.3.80[xcb] )
	qimageblitz? ( >=media-libs/qimageblitz-0.0.4 )
	qscintilla? ( x11-libs/qscintilla )
	qwt? ( x11-libs/qwt:5 )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

KMEXTRA="generator/"

KMSAVELIBS=1

src_configure() {
	mycmakeargs=(
		-DDISABLE_Qt3Support=ON
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_disable multimedia QtMultimedia)
		$(cmake-utils_use_with okular)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with qimageblitz QImageBlitz)
		$(cmake-utils_use_with qscintilla QScintilla)
		$(cmake-utils_use_disable qthelp QtHelp)
		$(cmake-utils_use_disable qwt)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_disable webkit QtWebKit)
	)
	kde4-meta_src_configure
}
