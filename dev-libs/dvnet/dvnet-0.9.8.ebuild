# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvnet/dvnet-0.9.8.ebuild,v 1.1 2003/07/14 19:50:23 pvdabeel Exp $

A=dvnet-${PV}.tar.gz
S=${WORKDIR}/dvnet-${PV}
DESCRIPTION="dvnet provides an interface wrapping sockets into streams"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvnet/download/${A}"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvnet/html/"
KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="virtual/glibc
	dev-libs/dvutil
	>=sys-apps/sed-4"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd ${S}
	elibtoolize
	aclocal
	autoconf
	automake
	sed -i 's:$(pkgdatadir:$(DESTDIR)\/$(pkgdatadir:' ${S}/doc/Makefile.am
}

src_install() {
    AUTOMAKE=1.7.3
	make DESTDIR=${D} prefix=${D}/usr install
}
