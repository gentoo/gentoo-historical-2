# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/watchpid/watchpid-0.1-r1.ebuild,v 1.8 2002/10/20 18:54:51 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Watches a process for termination"
SRC_URI="http://www.codepark.org/projects/utils/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.codepark.org/"
KEYWORDS="x86 -ppc"
SLOT="0"
LICENSE="GPL-2"
DEPEND="virtual/glibc"

src_compile() {
	./configure --prefix=/usr --mandir=/usr/share/man --host=${CHOST} || die
	make ${MAKEOPTS} || die
}

src_install() {
	make DESTDIR=${D} install || die
	cd ${S}
	dodoc README AUTHORS COPYING NEWS
}
