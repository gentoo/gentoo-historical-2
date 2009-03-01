# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-kde/phonon-kde-4.2.0-r1.ebuild,v 1.1 2009/03/01 00:24:51 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="!kde-base/phonon:${SLOT}
	!kdeprefix? ( !kde-base/phonon-xine )"
RDEPEND="${DEPEND}"

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
