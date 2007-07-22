# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xfig/xfig-3.2.4-r3.ebuild,v 1.10 2007/07/22 07:28:32 pva Exp $

inherit eutils multilib

MY_P=${PN}.${PV}
S=${WORKDIR}/${MY_P}
SHAPE_P=shape-patch.${PV}-shape-1.1

DESCRIPTION="A menu-driven tool to draw and manipulate objects interactively in an X window."
HOMEPAGE="http://www.xfig.org"
SRC_URI="http://www.xfig.org/xfigdist/${MY_P}.full.tar.gz
	http://www.ctan.org/tex-archive/graphics/transfig-shapepatch/${SHAPE_P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw
		x11-libs/libXp
		x11-libs/Xaw3d
		media-libs/jpeg
		media-libs/libpng
		media-gfx/transfig
		media-libs/netpbm"
DEPEND="${RDEPEND}
		x11-misc/imake
		app-text/rman
		x11-proto/xproto
		x11-proto/inputproto
		x11-libs/libXi"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-xaw3d.diff
	epatch ../${SHAPE_P}/${PN}.${SHAPE_P#*.}.patch	# bug #20877
	epatch ${FILESDIR}/${P}-gcc4.patch
}

src_compile() {
	xmkmf || die
	emake BINDIR=/usr/bin XFIGLIBDIR=/usr/$(get_libdir)/xfig || die
}

src_install() {

	emake -j1 \
		DESTDIR=${D} \
		BINDIR=/usr/bin \
		XFIGLIBDIR=/usr/$(get_libdir)/xfig \
		MANDIR=/usr/share/man/man1 \
		MANSUFFIX=1 \
		install install.all || die

	insinto /usr/share/doc/${P}
	doins README FIGAPPS CHANGES LATEX.AND.XFIG
	doins ../${SHAPE_P}/shapepatch.README
}
