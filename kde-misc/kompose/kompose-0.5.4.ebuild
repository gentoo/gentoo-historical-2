# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kompose/kompose-0.5.4.ebuild,v 1.8 2008/12/07 12:53:20 jmbsvicetto Exp $

inherit kde

DESCRIPTION="A KDE fullscreen task manager."
HOMEPAGE="http://kompose.berlios.de"
SRC_URI="mirror://berlios/kompose/${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="media-libs/imlib2"
RDEPEND="${DEPEND}"
need-kde 3.5

PATCHES=( "${FILESDIR}/${P}-ktoolbar-patch" )

function pkg_setup() {
	# bug 94881
	if ! built_with_use media-libs/imlib2 X; then
		eerror "This package requires imlib2 to be built with X11 support."
		eerror "Please run USE=X emerge media-libs/imlib2, then try emerging kompose again."
		die "imlib2 must be built with USE=X"
	fi
}

src_compile() {
	rm configure
	kde_src_compile
}
