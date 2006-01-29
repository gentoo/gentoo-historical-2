# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/gMOO/gMOO-0.4.8-r1.ebuild,v 1.11 2006/01/29 00:20:11 joshuabaergen Exp $

DESCRIPTION="GTK+ Based MOO client"
HOMEPAGE="http://www.nowmoo.demon.nl/"
SRC_URI="http://www.nowmoo.demon.nl/packages/${P}.tar.bz2"

KEYWORDS="x86 ppc ~amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls tcltk"

RDEPEND="virtual/libc
	|| ( x11-libs/libXi virtual/x11 )
	=x11-libs/gtk+-1.2*
	tcltk? ( dev-lang/tcl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	use nls && patch -l -p0 <${FILESDIR}/gMOO.patch
	sed -i \
		-e "s/-ltcl8.0/-ltcl/" configure \
			|| die "sed configure failed"
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable tcltk tcl) \
			|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README VERSION NEWS TODO ChangeLog || die "dodoc failed"
}
