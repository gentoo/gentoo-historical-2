# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audiocompress/audiocompress-1.5.ebuild,v 1.8 2005/12/18 21:48:18 flameeyes Exp $

MY_P="AudioCompress-${PV}"

DESCRIPTION="AudioCompress is (essentially) a very gentle, 1-band dynamic range compressor intended to keep audio output at a consistent volume without introducing any audible artifacts."
HOMEPAGE="http://beesbuzz.biz/code/"
SRC_URI="http://beesbuzz.biz/code/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="xmms"

DEPEND="xmms? ( media-sound/xmms )
	media-sound/esound"

S=${WORKDIR}/${MY_P}

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
