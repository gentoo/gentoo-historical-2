# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet/gnunet-0.4.6.ebuild,v 1.2 2002/08/27 16:47:07 rphillips Exp $

S="${WORKDIR}/GNUnet-${PV}"
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://www.ovmj.org/GNUnet/"
SRC_URI="http://www.ovmj.org/GNUnet/download/GNUnet-${PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-libs/openssl-0.9.6d
	>=sys-libs/gdbm-1.8.0
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=dev-libs/libextractor-0.1.0"

RDEPEND="${DEPEND}"

src_compile () {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README

	docinto contrib
	dodoc contrib/*
}
