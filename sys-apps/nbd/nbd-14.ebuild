# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/nbd/nbd-14.ebuild,v 1.9 2002/10/20 18:54:50 vapier Exp $

MY_P=${P//-/.}
S=${WORKDIR}/${PN}
DESCRIPTION="Userland client/server for kernel network block device"
SRC_URI="http://atrey.karlin.mff.cuni.cz/~pavel/nbd/${MY_P}.tar.gz"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~pavel/nbd/nbd.html"
KEYWORDS="x86 -ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=sys-devel/gcc-2.95.3
	>=sys-devel/make-3.79.1"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr || die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	mkdir -p ${D}/usr/bin
	make \
		prefix=${D}/usr \
		install || die "make install failed"
}
