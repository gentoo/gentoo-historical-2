# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/debianutils/debianutils-1.16.3.ebuild,v 1.13 2003/03/07 20:59:54 seemant Exp $

inherit eutils

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="A selection of tools from Debian"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz"
HOMEPAGE="http://packages.debian.org/unstable/base/debianutils.html"

KEYWORDS="x86 ppc sparc alpha mips hppa arm"
SLOT="0"
LICENSE="GPL-2 BSD SMAIL"
IUSE="static build"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	
	cd ${S}
	epatch ${FILESDIR}/${P}-Makefile-gentoo.diff

	# Make installkernel and mkboot more Gentoo friendly
	# <azarah@gentoo.org> (25 Sep 2002)
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	if [ -z "`use static`" ]
	then
		pmake || die
	else
		pmake LDFLAGS=-static || die
	fi
}

src_install() {
	into /
	dobin readlink tempfile mktemp

	if [ -z "`use build`" ]
	then
		dobin run-parts
		insopts -m755
		exeinto /usr/sbin
		doexe savelog
		dosbin installkernel
		into /usr
		dosbin mkboot
		
		into /usr
		doman mktemp.1 readlink.1 tempfile.1 run-parts.8 savelog.8 \
			installkernel.8 mkboot.8
			
		cd debian
		dodoc changelog control copyright
	fi
}
