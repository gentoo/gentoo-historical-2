# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gv/gv-3.6.4.ebuild,v 1.2 2009/12/26 17:31:42 pva Exp $

inherit autotools eutils

DESCRIPTION="gv is used to view PostScript and PDF documents using Ghostscript"
HOMEPAGE="http://www.gnu.org/software/gv/"
SRC_URI="mirror://gnu/gv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/Xaw3d
	app-text/ghostscript-gpl
	x11-libs/libXt"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gv-3.6.1-a0.patch

	# Make font render nicely even with gs-8, bug 135354
	sed -i \
		-e "s:-dGraphicsAlphaBits=2:\0 -dAlignToPixels=0:" \
		src/{gv_{class,user,system}.ad,Makefile.am} || die "sed failed."

	eautoreconf
}

src_compile() {
	econf --disable-dependency-tracking \
		--enable-scrollbar-code || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	doicon src/gv_icon.xbm
	make_desktop_entry gv "GhostView" /usr/share/pixmaps/gv_icon.xbm "Graphics;Viewer;"
	dodoc AUTHORS ChangeLog README
}
