# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pciutils/pciutils-2.1.11.ebuild,v 1.3 2003/09/19 21:10:13 joker Exp $

inherit eutils

S=${WORKDIR}/${P}
DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~mj/pciutils.html"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc sparc ~alpha ~hppa ~arm"

DEPEND="virtual/glibc
	net-misc/wget"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/pcimodules-${P}.diff

	sed -i "s:-O2:${CFLAGS}:" Makefile

	./update-pciids.sh
}

src_compile() {
	make PREFIX=/usr lib/config.h || die

	cd ${S}/lib
	sed -i "s:/usr/share/pci.ids:/usr/share/misc/pci.ids:" config.h || die

	cd ${S}
	make PREFIX=/usr || die

	for i in update-pciids lspci.8 update-pciids.8; do
		sed -i "s:/usr/share/pci.ids:/usr/share/misc/pci.ids:" ${i} || die
	done
}

src_install () {
	into /
	dosbin setpci lspci pcimodules update-pciids
	doman *.8

	insinto /usr/share/misc
	doins pci.ids

	dolib lib/libpci.a

	insinto /usr/include/pci
	doins lib/*.h
}
