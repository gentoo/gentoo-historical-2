# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xbattbar/xbattbar-1.4.2.ebuild,v 1.4 2004/06/24 22:38:22 agriffis Exp $

IUSE=""

DESCRIPTION="Advanced Power Management battery status display for X"
HOMEPAGE="http://iplab.aist-nara.ac.jp/member/suguru/xbattbar.html"
SRC_URI="http://iplab.aist-nara.ac.jp/member/suguru/${P/-/_}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
DEPEND="virtual/x11"

src_compile() {

	xmkmf -a || die "xmkmf failed"
	emake || die
}

src_install() {

	dobin xbattbar

	newman xbattbar.man xbattbar.1
	dodoc COPYING README copyright
}
