# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linuxfromscratch-text/linuxfromscratch-text-3.3.ebuild,v 1.12 2004/12/20 04:02:11 jhuebel Exp $

MY_P="LFS-BOOK-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="The Linux From Scratch Book. Text Format"
SRC_URI="http://ftp.linuxfromscratch.org/lfs-books/${PV}/${MY_P}.txt.bz2
	ftp://ftp.planetmirror.com/pub/lfs/lfs-books/${PV}/${MY_P}.txt.bz2
	ftp://ftp.no.linuxfromscratch.org/mirrors/lfs/lfs-books/${PV}/${MY_P}.txt.bz2
	http://ftp.nl.linuxfromscratch.org/linux/lfs/lfs-books/${PV}/${MY_P}.txt.bz2"
HOMEPAGE="http://www.linuxfromscratch.org/"

SLOT="0"
LICENSE="as-is"
IUSE=""
KEYWORDS="x86 ppc amd64"

src_unpack() {
	mkdir ${S} ; cd ${S}
	cp ${DISTDIR}/${A} .
	unpack ${A}
}

src_install() {
	dodoc *
}
