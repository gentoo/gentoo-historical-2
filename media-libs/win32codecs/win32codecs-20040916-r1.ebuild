# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/win32codecs/win32codecs-20040916-r1.ebuild,v 1.5 2005/02/07 17:07:26 chriswhite Exp $


DESCRIPTION="Win32 binary codecs for video and audio playback support"
SRC_URI="http://www1.mplayerhq.hu/MPlayer/releases/codecs/all-${PV}.tar.bz2"
HOMEPAGE="http://www.mplayerhq.hu/"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -ppc -sparc -alpha -amd64"
IUSE="quicktime real"

S=${WORKDIR}/all-${PV}

src_install() {
	cd ${S}

	if use real
	then
		mkdir -p ${D}/usr/lib/real
		mv *so.6.0 ${D}/usr/lib/real
	fi

	if use quicktime
	then
		mkdir -p ${D}/usr/lib/win32
		mv *.qtx *.qts qtmlClient.dll  ${D}/usr/lib/win32
	fi

	mkdir -p ${D}/usr/lib/win32
	mv *.dll *.ax *xa *.acm *.vwp *.drv *.DLL ${D}/usr/lib/win32
}
