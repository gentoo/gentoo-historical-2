# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork/kdeartwork-3.5.9.ebuild,v 1.4 2008/05/12 14:02:56 armin76 Exp $

EAPI="1"
inherit kde-dist

DESCRIPTION="KDE artwork package"

KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ppc64 sparc ~x86"
IUSE="opengl xscreensaver"

DEPEND="~kde-base/kdebase-${PV}
	media-libs/libart_lgpl
	opengl? ( virtual/opengl )
	xscreensaver? ( x11-misc/xscreensaver )"

src_compile() {
	local myconf="--with-dpms --with-libart
				$(use_with opengl gl)
				$(use_with xscreensaver)"

	kde_src_compile
}
