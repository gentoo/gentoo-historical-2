# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/schedutils/schedutils-0.0.5.ebuild,v 1.5 2002/10/04 21:28:36 vapier Exp $

DESCRIPTION="Utilities for manipulating kernel schedular parameters"
HOMEPAGE="http://tech9.net/rml/"
KEYWORDS="x86 -ppc"
LICENSE=GPL-2

RDEPEND="virtual/glibc"
DEPEND="$RDEPEND"
SLOT="0"

SRC_URI="http://tech9.net/rml/${P}.tar.gz"
S=${WORKDIR}/${P}

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	cp Makefile.in Makefile.in.orig
	sed -e "s:^CFLAGS =.*:CFLAGS = ${CFLAGS}:" \
			Makefile.in.orig > Makefile.in
}

src_compile() {
	./configure --prefix=/usr || die
	emake || die
}

src_install() {
	dodoc COPYING CREDITS ChangeLog INSTALL README
	dobin irqset lsrt taskset rt
	cd man
	doman irqset.1  lsrt.1  rt.1  taskset.1
}
