# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="A GTK+ 2.0 based 'post-it' note system."
HOMEPAGE="http://xpad.sourceforge.net/"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~sparc64 ~ppc"

DEPEND=">=x11-libs/gtk+-2.0.0"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

S=${WORKDIR}/${P}

src_compile() {
	emake || die "Compilation failed"
}

src_install () {
	make DESTDIR=${D} install || die "Installation failed"

	dodoc CHANGES COPYING README TODO
}
