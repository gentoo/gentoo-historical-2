# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpeg2-movie/mpeg2-movie-1.5-r1.ebuild,v 1.6 2003/02/13 13:29:55 vapier Exp $

MY_P=${P/-/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An MPEG2 encoder"
SRC_URI="http://heroinewarrior.com/${MY_P}.tar.gz"
HOMEPAGE="http://heroinewarrior.com/mpeg2movie.php3"

DEPEND="=dev-libs/glib-1.2*
	>=media-libs/libpng-1.2.1
	>=dev-lang/nasm-0.98"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {

	export CFLAGS="${CFLAGS} `glib-config --cflags`"
	econf || die
	make -e CFLAGS="${CFLAGS}" || die

}

src_install () {
	into /usr
	newbin video/encode mpeg2_video_encode
	newbin audio/encode mpeg2_audio_encode
	newbin mplex/mplex mpeg2_mplex
	dobin libmpeg3/mpeg3cat
	dodoc script video/CHANGES video/TODO
	dohtml docs/index.html

}
