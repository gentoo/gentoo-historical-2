# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smoke/smoke-4.6.3.ebuild,v 1.1 2011/05/07 10:47:55 scarabeus Exp $

EAPI=4

DECLARATIVE_REQUIRED="optional"
MULTIMEDIA_REQUIRED="optional"
QTHELP_REQUIRED="optional"
WEBKIT_REQUIRED="optional"

KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	eclass=kde4-base
else
	KMNAME="kdebindings"
	eclass=kde4-meta
fi

inherit ${eclass}

DESCRIPTION="Scripting Meta Object Kompiler Engine"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="akonadi attica debug kate okular +phonon qimageblitz qscintilla qwt semantic-desktop"

COMMON_DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop=')
	akonadi? ( $(add_kdebase_dep kdepimlibs) )
	attica? ( dev-libs/libattica )
	kate? ( $(add_kdebase_dep kate) )
	okular? ( $(add_kdebase_dep okular) )
	phonon? ( >=media-libs/phonon-4.4.3 )
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
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_disable kate)
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
	${eclass}_src_configure
}
