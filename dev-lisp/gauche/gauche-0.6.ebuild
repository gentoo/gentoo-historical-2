# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/gauche/gauche-0.6.ebuild,v 1.3 2002/12/07 06:23:14 jmorgan Exp $

S=${WORKDIR}/Gauche-${PV}
DESCRIPTION="A Unix system friendly scheme interpreter"
SRC_URI="mirror://sourceforge/gauche/Gauche-${PV}.tgz"
HOMEPAGE="http://gauche.sf.net"
DEPEND="virtual/glibc"
RDEPEND="$DEPEND"
SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 sparc"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
	#make || die
}

src_install () {
#	make DESTDIR=${D} install || die
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dodoc COPYING INSTALL ChangeLog VERSION 
	doman doc/gosh.1 doc/gauche-config.1
	dodoc doc/README
}
