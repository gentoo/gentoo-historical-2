# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/ccsh/ccsh-0.0.4-r2.ebuild,v 1.9 2002/10/20 18:40:47 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="UNIX Shell for people already familiar with the C language"
SRC_URI="http://download.sourceforge.net/ccsh/${P}.tar.gz"
HOMEPAGE="http://ccsh.sourceforge.net"
KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	
	make CFLAGS="${CFLAGS}" all
}

src_install() {                               

	into /
	dobin ccsh
	into /usr
	newman ccsh.man ccsh.1
	dodoc ChangeLog COPYING README TODO

}





