# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wayv/wayv-0.3-r1.ebuild,v 1.4 2007/07/22 03:39:25 dberkholz Exp $

DESCRIPTION="Wayv is hand-writing/gesturing recognition software for X"
HOMEPAGE="http://www.stressbunny.com/wayv"
SRC_URI="http://www.stressbunny.com/gimme/wayv/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_install() {
	einstall || die
	cd doc
	einstall || die
	dodoc HOWTO*
}
