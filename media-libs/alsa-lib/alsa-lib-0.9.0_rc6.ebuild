# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alsa-lib/alsa-lib-0.9.0_rc6.ebuild,v 1.5 2002/12/31 15:20:59 doctomoe Exp $

MY_P=${P/_rc/rc}
S=${WORKDIR}/${MY_P}
SRC_URI="ftp://ftp.alsa-project.org/pub/lib/${MY_P}.tar.bz2"
DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="http://www.alsa-project.org/"

SLOT="0"
KEYWORDS="x86 ~ppc"
LICENSE="GPL-2 LGPL-2.1"

DEPEND="virtual/glibc"

src_compile() {                           

	econf || die "./configure failed"

	make || die "make failed"
}

src_install() {

	einstall || die "Installation Failed"

	#This alsa version does not provide libasound.so.1
	#Without this library just about everything even remotely
	#linked to previous versions of alsa-lib will break.
	#Fortunately, libasound.so.2 seems to be backwards
	#compatible with libasound.so.2 and a simple link
	#fixes the problem (fingers crossed)
	dosym /usr/lib/libasound.so.2 /usr/lib/libasound.so.1
	
	dodoc ChangeLog COPYING TODO 
}
