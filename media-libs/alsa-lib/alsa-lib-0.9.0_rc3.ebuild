# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alsa-lib/alsa-lib-0.9.0_rc3.ebuild,v 1.8 2003/02/13 12:40:23 vapier Exp $

MY_P=${P/_rc/rc}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="ftp://ftp.alsa-project.org/pub/lib/${MY_P}.tar.bz2"

DEPEND="virtual/glibc 
	~media-sound/alsa-driver-0.9.0_rc3"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc "
LICENSE="GPL-2 LGPL-2.1"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/configure.diff || die "patch failed"

}

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
