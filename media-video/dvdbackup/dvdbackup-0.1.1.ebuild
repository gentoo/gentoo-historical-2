# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdbackup/dvdbackup-0.1.1.ebuild,v 1.2 2003/07/12 21:12:37 aliz Exp $

DESCRIPTION="Backup content from DVD to hard disk"
HOMEPAGE="http://dvd-create.sourceforge.net/"
SRC_URI="http://dvd-create.sourceforge.net/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="media-libs/libdvdread"

S=${WORKDIR}/${PN}

src_compile() {
	cd ${S}
	gcc -o dvdbackup -I/usr/include/dvdread -ldvdread src/dvdbackup.c
}

src_install() {
	dobin dvdbackup
	dodoc README
}
