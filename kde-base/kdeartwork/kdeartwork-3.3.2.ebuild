# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork/kdeartwork-3.3.2.ebuild,v 1.10 2005/02/19 13:51:18 greg_g Exp $

inherit kde-dist eutils

DESCRIPTION="KDE artwork package"

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="opengl xscreensaver"

DEPEND="opengl? ( virtual/opengl )
	~kde-base/kdebase-${PV}
	!ppc64? ( xscreensaver? ( x11-misc/xscreensaver ) )"

src_unpack() {
	kde_src_unpack
	sed -ie "s:X11R6/lib\(/X11\)\?:lib:g" kscreensaver/kxsconfig/Makefile.am

	# Fix compilation with --without-gl. See bug #46775 and kde bug 89387.
	epatch ${FILESDIR}/${P}-gl-kdesavers.patch

	make -f admin/Makefile.common
}

src_compile() {
	myconf="$myconf --with-dpms $(use_with opengl gl)"
	kde_src_compile
}
