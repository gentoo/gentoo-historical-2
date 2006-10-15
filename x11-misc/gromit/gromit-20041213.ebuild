# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gromit/gromit-20041213.ebuild,v 1.4 2006/10/15 12:19:51 dertobi123 Exp $

DESCRIPTION="GRaphics Over MIscellaneous Things, a presentation helper"

HOMEPAGE="http://www.home.unix-ag.org/simon/gromit/"
SRC_URI="http://www.home.unix-ag.org/simon/gromit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

IUSE=""

DEPEND=">=x11-libs/gtk+-2.0"

src_unpack() {
	unpack ${A}

	sed -i "s:-Wall:-Wall ${CFLAGS}:" ${S}/Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	exeinto /usr/bin
	doexe gromit

	newdoc gromitrc gromitrc.example

	dodoc AUTHORS ChangeLog README
}
