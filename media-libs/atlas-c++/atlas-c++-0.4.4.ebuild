# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/atlas-c++/atlas-c++-0.4.4.ebuild,v 1.3 2002/07/11 06:30:38 drobbins Exp $

S="${WORKDIR}/Atlas-C++-${PV}"
SRC_URI="ftp://victor.worldforge.org/pub/worldforge/libs/Atlas-C++/Atlas-C++-0.4.4.tar.bz2"
HOMEPAGE="http://www.worldforge.net"
SLOT="0"
DEPEND="virtual/glibc
	( <dev-libs/libsigc++-1.1.0
	  >=dev-libs/libsigc++-1.0.4-r1 )"

src_compile() {

	./configure --host=${CHOST} --prefix=/usr || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die

}
