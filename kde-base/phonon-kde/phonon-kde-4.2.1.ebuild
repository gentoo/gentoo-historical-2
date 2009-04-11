# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-kde/phonon-kde-4.2.1.ebuild,v 1.5 2009/04/11 16:30:42 armin76 Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"
LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND="
	!kdeprefix? ( !kde-base/phonon-xine[-kdeprefix] )
"

src_prepare() {
	# Don't build tests - they require OpenGL
	sed -i -e 's/add_subdirectory(tests)//'\
		phonon/CMakeLists.txt || die "Failed to disable tests"

	kde4-meta_src_prepare
}

src_install() {
	kde4-meta_src_install

	# fix missing backends
	if use kdeprefix; then
		dosym /usr/share/kde4/services/phononbackends \
		"${KDEDIR}"/share/kde4/services/phononbackends || die
	fi
}
