# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audiocompress/audiocompress-1.3.ebuild,v 1.6 2004/06/08 01:38:53 agriffis Exp $

MY_P="AudioCompress-${PV}"

DESCRIPTION="AudioCompress is (essentially) a very gentle, 1-band dynamic range compressor intended to keep audio output at a consistent volume without introducing any audible artifacts."
HOMEPAGE="http://trikuare.cx/code/AudioCompress.html"
SRC_URI="http://trikuare.cx/code/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="xmms"

DEPEND="xmms? ( media-sound/xmms )"

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
	dodoc COPYING ChangeLog README TODO
}
