# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmCalClock/wmCalClock-1.25-r2.ebuild,v 1.1 2008/02/12 16:24:03 s4t4n Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="WMaker DockApp: A Calendar clock with antialiased text."
SRC_URI="http://www.dockapps.org/download.php/id/16/${P}.tar.gz"
HOMEPAGE="http://www.dockapps.org/file.php/id/9"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~alpha ~amd64 ~mips ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/${P}/Src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc ../{BUGS,CHANGES,HINTS,README,TODO}
}
