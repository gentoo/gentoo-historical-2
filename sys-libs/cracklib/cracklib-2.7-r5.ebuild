# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/cracklib/cracklib-2.7-r5.ebuild,v 1.4 2002/07/09 12:51:08 aliz Exp $

S=${WORKDIR}/cracklib,${PV}
DESCRIPTION="Cracklib"
SRC_URI="ftp://ftp.debian.org/debian/dists/potato/main/source/utils/cracklib2_${PV}.orig.tar.gz"
DEPEND="virtual/glibc sys-apps/miscfiles"
LICENSE="CRACKLIB"
KEYWORDS="x86"
SLOT="0"

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

	preplib /usr/lib

	dodoc HISTORY LICENCE MANIFEST POSTER README
}
