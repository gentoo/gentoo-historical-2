# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/levee/levee-3.4o.ebuild,v 1.22 2009/08/12 20:39:01 vostorga Exp $

IUSE=""

S=${WORKDIR}/${PN}
DESCRIPTION="Really tiny vi clone, for things like rescue disks"
HOMEPAGE="http://www.pell.chi.il.us/~orc/Code/"
SRC_URI="http://www.pell.chi.il.us/~orc/Code/${PN}.tar.gz"

SLOT="0"
LICENSE="levee"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="!app-text/lv
	sys-libs/ncurses"

src_compile() {
	sed -i -e "/^CFLAGS/ s:-O:${CFLAGS}:" Makefile
	make LIBES=-lncurses || die
}

src_install() {
	exeinto /usr/bin
	newexe lev lv
	doman lv.1
}
