# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxcomp/nxcomp-1.3.2.ebuild,v 1.4 2004/06/25 00:01:03 agriffis Exp $

MY_P="${PN}-1.3.2-4"
DESCRIPTION="X11 protocol compression library"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="http://www.nomachine.com/download/nxsources/nxcomp/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
DEPEND=">=media-libs/jpeg-6b-r3
>=media-libs/libpng-1.2.5-r4
>=sys-devel/gcc-3.2.3-r2
>=sys-libs/glibc-2.3.2-r3
>=sys-libs/zlib-1.1.4-r2
virtual/x11"

# Run-time dependencies, same as DEPEND if RDEPEND isn't defined:
#RDEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	./configure
	DISTCC_HOSTS="localhost" CCACHE_DISABLE="1" emake || die "compile problem"
}

src_install() {
	dolib libXcomp.so.${PV}
	preplib

	dodoc README README-IPAQ LICENSE VERSION

	insinto /usr/NX/include
	doins NX.h
}
