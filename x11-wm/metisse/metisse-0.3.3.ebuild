# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/metisse/metisse-0.3.3.ebuild,v 1.3 2005/02/20 10:55:13 usata Exp $

inherit eutils

# fc is broken
IUSE="freetype xv"

DESCRIPTION="Experimental X desktop with some OpenGL capacity."
SRC_URI="http://insitu.lri.fr/~chapuis/software/metisse/${P}.tar.bz2"
HOMEPAGE="http://insitu.lri.fr/~chapuis/metisse"

DEPEND="virtual/x11
	>=x11-libs/nucleo-0.1-r1"
RDEPEND="${DEPEND}
	!x11-wm/fvwm"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/metisse-0.3.1-FvwmGtk.1-DESTDIR.diff
}

src_compile() {
	econf \
		$(use_enable xv) \
		$(use_enable freetype) \
		|| die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
