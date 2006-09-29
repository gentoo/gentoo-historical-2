# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kompose/kompose-0.5.3.ebuild,v 1.7 2006/09/29 13:32:38 deathwing00 Exp $

inherit kde

DESCRIPTION="A KDE fullscreen task manager."
HOMEPAGE="http://kompose.berlios.de"
#SRC_URI="http://download.berlios.de/kompose/${P}.tar.bz2"
# 0.5.3 tarball was reissued upstream...
SRC_URI="mirror://gentoo/${P}g.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="media-libs/imlib2"
RDEPEND="${DEPEND}"
need-kde 3.2

function pkg_setup() {
	# bug 94881
	if ! built_with_use media-libs/imlib2 X; then
		eerror "This package requires imlib2 to be built with X11 support."
		eerror "Please run USE=X emerge media-libs/imlib2, then try emerging kompose again."
		die "imlib2 must be built with USE=X"
	fi
}
