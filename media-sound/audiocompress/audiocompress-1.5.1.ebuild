# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audiocompress/audiocompress-1.5.1.ebuild,v 1.7 2005/12/18 21:48:18 flameeyes Exp $

IUSE="xmms"

inherit eutils

MY_P="AudioCompress-${PV}"

DESCRIPTION="AudioCompress is (essentially) a very gentle, 1-band dynamic range compressor intended to keep audio output at a consistent volume without introducing any audible artifacts."
HOMEPAGE="http://beesbuzz.biz/code/"
SRC_URI="http://beesbuzz.biz/code/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 1.5.1 - Floating point exception when using xmms plugin
#-sparc: 1.5.5 - Gdk-ERROR **: BadValue (integer parameter out of range for operation) serial 7 error_code 2 request_code 1 minor_code 0
KEYWORDS="-amd64 ~ppc -sparc x86"

DEPEND="xmms? ( media-sound/xmms )
	media-sound/esound"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	cd ${S}
	make clean

	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	if use xmms; then
		emake || die
	else
		emake AudioCompress || die
	fi
}

src_install() {
	dobin AudioCompress || die
	if use xmms; then
		exeinto "$(xmms-config --effect-plugin-dir)" || die
		doexe libcompress.so || die
	fi
	dodoc ChangeLog README TODO
}
