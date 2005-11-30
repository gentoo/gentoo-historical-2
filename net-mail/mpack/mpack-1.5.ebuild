# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mpack/mpack-1.5.ebuild,v 1.1 2002/06/12 13:03:49 stroke Exp $

DESCRIPTION="Command-line MIME encoding and decoding utilities"
HOMEPAGE="ftp://ftp.andrew.cmu.edu/pub/mpack/"
LICENSE="as-is"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/mpack/${P}-src.tar.Z"
SLOT="0"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

S=${WORKDIR}/mpack

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install () {
	dodir /usr
	make DESTDIR=${D}/usr install || die
}
