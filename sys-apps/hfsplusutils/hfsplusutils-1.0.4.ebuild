# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hfsplusutils/hfsplusutils-1.0.4.ebuild,v 1.12 2002/12/09 04:37:25 manson Exp $

S=${WORKDIR}/hfsplus-${PV}
MY_P="hfsplus_${PV}"
DESCRIPTION="HFS+ Filesystem Access Utilities (PPC Only)"
SRC_URI="http://ftp.penguinppc.org/users/hasi/${MY_P}.src.tar.bz2"
HOMEPAGE="http://ftp.penguinppc.org/users/hasi/"

KEYWORDS="ppc -x86 -sparc  -alpha"
LICENSE="GPL-2"
SLOT="0"

DEPEND="sys-devel/autoconf
	sys-devel/automake
	sys-apps/bzip2"
RDEPEND=""

MAKEOPTS='PREFIX=/usr MANDIR=/usr/share/man'

src_compile() {
	# This does a autoconf, automake, etc.
	emake -f Makefile.cvs all || die

	patch -p0 < ${FILESDIR}/hfsplusutils-1.0.4-glob.patch || die "Patch failed"

	econf
	emake || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/lib
	dodir /usr/share/man
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dodir /usr/share/man/man1
	cp doc/man/hfsp.man ${D}/usr/share/man/man1/hfsp.1
}
