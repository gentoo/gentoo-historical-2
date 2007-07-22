# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/Tk_Theme/Tk_Theme-23.ebuild,v 1.13 2007/07/22 07:34:22 graaff Exp $

DESCRIPTION="Theming library for TCL/TK."
HOMEPAGE="http://www.xmission.com/~georgeps/Tk_Theme/"
SRC_URI="http://www.xmission.com/~georgeps/Tk_Theme/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

IUSE=""

RDEPEND="dev-lang/tcl
	dev-lang/tk
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="$RDEPEND
	x11-proto/xextproto"

src_compile() {
	tclsh configure || die 'configure failed'
	emake || die 'emake failed'
}

src_install() {
	local libdir=/usr/lib/Tk_Theme

	insinto ${libdir}
	doins *.tcl
	exeinto ${libdir}
	doexe theme.so

	dodoc Changes LICENSE README TODO
}
