# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics/kdegraphics-2.2.2-r1.ebuild,v 1.6 2003/03/11 21:11:45 seemant Exp $
inherit kde-dist eutils

IUSE="tetex gphoto2"
DESCRIPTION="KDE $PV - graphics-related apps"
KEYWORDS="x86 sparc "
DEPEND="$DEPEND dev-lang/perl
	media-gfx/sane-backends
	tetex? ( >=app-text/tetex-1.0.7 )"

newdepend "gphoto2? ( >=media-gfx/gphoto2-2.0_beta1 )"

SRC_URI="${SRC_URI}
	mirror://kde/security_patches/post-${PV}-${PN}.diff"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	epatch ${DISTDIR}/post-${PV}-${PN}.diff
	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	kde_src_compile myconf

	use gphoto2 && myconf="$myconf --with-gphoto2-includes=/usr/include/gphoto2 --with-gphoto2-libraries=/usr/lib/gphoto2" || myconf="$myconf --without-kamera"
	use tetex && myconf="$myconf --with-system-kpathsea --with-tex-datadir=/usr/share"
	kde_src_compile configure make
}
