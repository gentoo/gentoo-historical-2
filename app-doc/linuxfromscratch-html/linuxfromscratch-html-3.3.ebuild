# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linuxfromscratch-html/linuxfromscratch-html-3.3.ebuild,v 1.8 2003/02/13 06:36:32 vapier Exp $

MY_P="LFS-BOOK-${PV}-HTML"
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Linux From Scratch Book. HTML Format"
SRC_URI="http://ftp.linuxfromscratch.org/lfs-books/${PV}/${MY_P}.tar.bz2
	ftp://ftp.planetmirror.com/pub/lfs/lfs-books/${PV}/${MY_P}.tar.bz2
	ftp://ftp.no.linuxfromscratch.org/mirrors/lfs/lfs-books/${PV}/${MY_P}.tar.bz2
	http://ftp.nl.linuxfromscratch.org/linux/lfs/lfs-books/${PV}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.linuxfromscratch.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc "

src_install() {
	dodir /usr/share/doc/linuxfromscratch-html-${PV}
	cp -R * ${D}/usr/share/doc/linuxfromscratch-html-${PV}
}
