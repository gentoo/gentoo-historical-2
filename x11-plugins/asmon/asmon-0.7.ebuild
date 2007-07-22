# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/asmon/asmon-0.7.ebuild,v 1.7 2007/07/22 05:39:35 dberkholz Exp $

inherit eutils toolchain-funcs

DESCRIPTION="WindowMaker/AfterStep system monitor dockapp"
HOMEPAGE="http://rio.vg/asmon/"
SRC_URI="http://rio.vg/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="alpha ~amd64 ppc sparc x86"

RDEPEND="x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}.cflags.diff
	sed -i -e "s:gcc -c:$(tc-getCC) -c:g" \
	    asmon/Makefile || die "sed failed in Makefile"
}

src_compile() {
	cd ${S}/asmon
	make clean
	emake || die
}

src_install() {
	dodoc Changelog
	newicon ${PN}.icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "System;Monitor"
	dobin asmon/${PN}
}
