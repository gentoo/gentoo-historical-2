# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdaliclock/xdaliclock-2.19.ebuild,v 1.3 2003/02/13 17:19:54 vapier Exp $

S=${WORKDIR}/${P}/X11
DESCRIPTION=" Dali Clock is a digital clock. When a digit changes, it melts into its new shape."
HOMEPAGE="http://www.jwz.org/xdaliclock/"
SRC_URI="http://www.jwz.org/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

IUSE=""

DEPEND="virtual/x11"


src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	einstall || die

	dodoc README
}
