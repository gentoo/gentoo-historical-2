# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/mowitz/mowitz-0.2.1.ebuild,v 1.1 2002/06/05 04:02:54 lostlogic Exp $

S=${WORKDIR}/Mowitz-${PV}

SRC_URI="http://siag.nu/pub/mowitz/Mowitz-${PV}.tar.gz"
HOMEPAGE="http://siag.nu/mowitz/"
DESCRIPTION="Mowitz - more widgets library"
LICENSE="GPL"
SLOT="0"

DEPEND=">=x11-base/xfree-4.2.0
        >=media-libs/t1lib-1.0.1"
RDEPEND="${DEPEND}"

src_compile() {
	./configure --prefix=/usr \
		    --mandir=/usr/share/man \
		    --with-xawm=Xaw \
		    --with-t1lib || die "Configure broke"
	emake || die "Make broke"
}

src_install() {
	make DESTDIR=${D} install
}


