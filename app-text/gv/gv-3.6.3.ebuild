# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gv/gv-3.6.3.ebuild,v 1.2 2007/07/22 10:21:01 omp Exp $

inherit eutils

DESCRIPTION="gv is used to view PostScript and PDF documents using Ghostscript"
HOMEPAGE="http://www.gnu.org/software/gv/"
SRC_URI="mirror://gnu/gv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/Xaw3d
	virtual/ghostscript"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gv-3.6.1-setenv.patch
	epatch "${FILESDIR}"/gv-3.6.1-a0.patch
	# Make font render nicely even with gs-8, bug 135354
	sed -i -e "s:-dGraphicsAlphaBits=2:\0 -dAlignToPixels=0:" \
		src/{gv_{class,user,system}.ad,Makefile.{am,in}}
}

src_compile() {
	econf --enable-scrollbar-code || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	doicon src/gv_icon.xbm
	make_desktop_entry gv "GhostView" /usr/share/pixmaps/gv_icon.xbm "Application;Graphics;Viewer;"
	dodoc AUTHORS ChangeLog INSTALL README TODO
}
