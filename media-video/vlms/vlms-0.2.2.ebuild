# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlms/vlms-0.2.2.ebuild,v 1.4 2003/02/13 13:36:49 vapier Exp $

DESCRIPTION="The VideoLAN mini-server"
HOMEPAGE="http://www.videolan.org/vlms/"
SRC_URI="http://www.videolan.org/pub/videolan/vlms/0.2.2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -ppc -sparc "

DEPEND=">=media-libs/libdvdread-0.9.3
	>=media-libs/libdvdcss-1.2.1
	>=media-libs/libdvbpsi-0.1.1"
#RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {

	make prefix=/usr || die "emake failed"

}

src_install () {

	dodir /usr/bin
	make prefix=${D}/usr install || die "einstall failed"

}
