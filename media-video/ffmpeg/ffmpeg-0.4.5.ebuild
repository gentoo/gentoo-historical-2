# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.5.ebuild,v 1.9 2002/12/09 04:26:14 manson Exp $

S=${WORKDIR}/ffmpeg
DESCRIPTION="Tool to manipulate and stream video files"
SRC_URI="mirror://sourceforge/ffmpeg/${P}.tar.gz"
HOMEPAGE="http://ffmpeg.sourceforge.net/"

inherit flag-o-matic
filter-flags -fforce-addr

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc "

DEPEND="dev-lang/nasm"

src_compile() {
	local myconf

	use mmx || myconf="--disable-mmx"

	./configure ${myconf} || die
	make || die
}

src_install() {
	dobin ffmpeg ffserver
	dodoc doc/*
}
