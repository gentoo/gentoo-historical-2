# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mclient/mclient-2.8.ebuild,v 1.2 2004/06/24 22:29:17 agriffis Exp $

DESCRIPTION="Simple command line Masqdialer client"
HOMEPAGE="http://cpwright.com/mserver/"
SRC_URI="http://cpwright.com/cli-mclient/cli-${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/glibc"

src_compile() {
	sed -i -e "s:-O2:${CFLAGS}:" Makefile
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe mclient
	dodoc CHANGES DISCLAIMER LICENSE
}
