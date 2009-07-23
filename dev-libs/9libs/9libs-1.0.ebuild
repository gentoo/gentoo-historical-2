# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/9libs/9libs-1.0.ebuild,v 1.15 2009/07/23 23:38:30 vostorga Exp $

inherit toolchain-funcs

DESCRIPTION="A package of Plan 9 compatibility libraries"
HOMEPAGE="http://www.netlib.org/research/9libs/9libs-1.0.README"
SRC_URI="ftp://www.netlib.org/research/9libs/${P}.tar.bz2"

LICENSE="PLAN9"
SLOT="0"
KEYWORDS="sparc x86"
IUSE=""

DEPEND=">=x11-proto/xproto-7.0.4
	>=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		--includedir=/usr/include/9libs \
		--enable-shared \
		|| die "econf failed"
	emake CC="$(tc-getCC)" || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc README
}
