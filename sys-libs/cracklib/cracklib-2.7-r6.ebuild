# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/cracklib/cracklib-2.7-r6.ebuild,v 1.1 2002/10/25 23:22:05 raker Exp $

S=${WORKDIR}/cracklib,${PV}
DESCRIPTION="Cracklib"
SRC_URI="ftp://ftp.debian.org/debian/dists/potato/main/source/utils/cracklib2_${PV}.orig.tar.gz"
DEPEND="virtual/glibc sys-apps/miscfiles"
LICENSE="CRACKLIB"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
SLOT="0"
HOMEPAGE="http://www.users.dircon.co.uk/~crypto/"

src_unpack() {

 	unpack ${A}
	cd ${S}
	patch -p1 <${FILESDIR}/${P}-redhat.patch || die
	patch -p1 <${FILESDIR}/${P}-gentoo-new.diff || die
}

src_compile() {
	# Parallel make does not work for 2.7
	make all || die
}

src_install() {

	dodir /usr/{lib,sbin,include} /usr/share/cracklib

	make DESTDIR=${D} install || die

	# This link is needed and not created. :| bug #9611
	cd ${D}/usr/lib
	dosym libcrack.so.2.7 /usr/lib/libcrack.so.2
	cd ${S}

	preplib /usr/lib

	dodoc HISTORY LICENCE MANIFEST POSTER README
}
