# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/nxtvepg/nxtvepg-2.7.6.ebuild,v 1.2 2006/11/24 11:51:26 phosphan Exp $

inherit eutils

DESCRIPTION="receive and browse free TV programme listings via bttv for tv networks in Europe"
HOMEPAGE="http://nxtvepg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/tcl-8.0
	>=dev-lang/tk-8.0
	x11-libs/libX11
	x11-libs/libXmu"

DEPEND="${RDEPEND}
	sys-apps/sed
	sys-kernel/linux-headers
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/nxtvepg-db.patch
}

src_compile() {
	make prefix="/usr" || die "make failed"
}

src_install() {
	make install ROOT=${D} prefix="/usr" || die "install failed"
	dodoc README COPYRIGHT CHANGES TODO
	dohtml manual.html
}
