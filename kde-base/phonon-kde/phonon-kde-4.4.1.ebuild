# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-kde/phonon-kde-4.4.1.ebuild,v 1.1 2010/03/02 19:36:55 tampakrap Exp $

EAPI="3"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="alsa debug +xine"

DEPEND="
	>=media-sound/phonon-4.3.80[xine?]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.4-optional-alsa.patch
)

src_prepare() {
	kde4-meta_src_prepare

	# Don't build tests - they require OpenGL
	sed -e 's/add_subdirectory(tests)//' \
		-i phonon/CMakeLists.txt || die "Failed to disable tests"

}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with xine)
	)

	kde4-meta_src_configure
}
