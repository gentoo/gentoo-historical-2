# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vcp/vcp-2.2.ebuild,v 1.2 2005/01/01 15:28:31 eradicator Exp $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="copy files/directories in a curses interface"
HOMEPAGE="http://members.iinet.net.au/~lynx/vcp/"
SRC_URI="http://members.iinet.net.au/~lynx/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="sys-libs/ncurses"

src_compile() {
	filter-lfs-flags
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin vcp || die "dobin failed"
	doman vcp.1 || die "doman failed"
	insinto /etc
	newins vcp.conf.sample vcp.conf || die "newins failed"
	dodoc Changelog README INSTALL || die "dodoc failed"
}
