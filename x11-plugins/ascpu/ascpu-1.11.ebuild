# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/ascpu/ascpu-1.11.ebuild,v 1.2 2006/11/22 15:15:15 josejx Exp $

inherit eutils toolchain-funcs

IUSE="jpeg"
DESCRIPTION="CPU statistics monitor utility for X Windows"
SRC_URI="http://www.tigr.net/afterstep/download/ascpu/${P}.tar.gz"
HOMEPAGE="http://www.tigr.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~mips ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/libXpm
	x11-libs/libSM
	jpeg? ( media-libs/jpeg )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	econf $(use_enable jpeg) || die "econf failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
