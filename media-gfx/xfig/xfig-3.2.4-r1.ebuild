# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2.
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xfig/xfig-3.2.4-r1.ebuild,v 1.2 2003/07/12 16:44:48 aliz Exp $

inherit eutils

IUSE=""

MY_P=${PN}.${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A menu-driven tool to draw and manipulate objects interactively in an X window."
HOMEPAGE="http://www.xfig.org"
SRC_URI="http://www.xfig.org/xfigdist/${MY_P}.full.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~hppa"

DEPEND="virtual/x11
	x11-libs/Xaw3d
	media-libs/jpeg
	media-libs/libpng"

RDEPEND="${DEPEND}
	media-gfx/transfig
	media-libs/netpbm"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-xaw3d.diff
}

src_compile() {
	xmkmf || die
	make || die
}

src_install () {
	make \
		DESTDIR=${D} \
		install || die

	make \
		DESTDIR=${D} \
		MANDIR=/usr/share/man/man1 \
		MANSUFFIX=1 \
		install.all || die

	dodoc README FIGAPPS CHANGES LATEX.AND.XFIG
}
