# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/palo/palo-1.2_pre20030630.ebuild,v 1.1 2003/07/01 21:52:21 gmsoft Exp $

MY_V=${PV/_pre/-CVS}
DESCRIPTION="PALO : PArisc Linux Loader"
HOMEPAGE="http://parisc-linux.org/"
SRC_URI="http://ftp.parisc-linux.org/cvs/palo-${MY_V}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

S=${WORKDIR}/palo

#Compile only on hppa stations
KEYWORDS="hppa -*"
IUSE=""

PROVIDE="virtual/bootloader"

DEPEND=">=glibc-2.2.4"

src_compile() {
	emake -C palo CFLAGS="${CFLAGS} -I../include -I../lib" || die
	emake -C ipl CFLAGS="${CFLAGS} -I. -I../lib -I../include -fwritable-strings -mdisable-fpregs -Wall" || die
	emake MACHINE=parisc iplboot
	emake || die
}

src_install() {
	dosbin palo/palo
	doman palo.8
	dohtml README.html
	dodoc README
	dodoc palo.conf

	insinto /etc
	doins ${FILESDIR}/palo.conf	

	insinto /usr/share/palo
	doins iplboot
}
