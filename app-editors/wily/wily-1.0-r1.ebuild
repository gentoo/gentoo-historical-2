# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/wily/wily-1.0-r1.ebuild,v 1.1 2006/01/21 19:41:06 vanquirius Exp $

inherit toolchain-funcs

MY_P="${P/1.0/9libs}"

DESCRIPTION="An emulation of ACME, Plan9's hybrid window system, shell and editor for programmers."
HOMEPAGE="http://www.netlib.org/research/9libs/"
SRC_URI="ftp://www.netlib.org/research/9libs/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/9libs
	( || (
	( >=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libICE-1.0.0
	>=x11-libs/libSM-1.0.0 )
	virtual/x11 )
	)"

S="${WORKDIR}/${MY_P}"

src_compile() {
	export CC="$(tc-getCC)"
	econf --includedir="/usr/include/9libs" || die "configure failed."
	emake || die "make failed."
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
	dodoc README
	insinto /usr/share/${PN}
	doins "${S}"/misc/*
}

