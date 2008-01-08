# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdaliclock/xdaliclock-2.24.ebuild,v 1.3 2008/01/08 01:48:37 ranger Exp $

DESCRIPTION=" Dali Clock is a digital clock. When a digit changes, it melts into its new shape."
HOMEPAGE="http://www.jwz.org/xdaliclock"
SRC_URI="http://www.jwz.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

S="${WORKDIR}"/${P}/X11

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	emake install_prefix="${D}" install || die "emake install failed."
	dodoc ../README
}
