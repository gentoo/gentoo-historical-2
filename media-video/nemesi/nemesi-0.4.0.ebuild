# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nemesi/nemesi-0.4.0.ebuild,v 1.3 2004/12/18 20:42:16 lu_zero Exp $

DESCRIPTION="Tiny rtsp client"
HOMEPAGE="http://streaming.polito.it/"
SRC_URI="http://streaming.polito.it/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="gtk sdl"

DEPEND="sys-libs/glibc
		gtk? ( >=x11-libs/gtk+-2.4 )
		sdl? ( media-libs/libsdl )
		media-video/ffmpeg"

export WANT_AUTOMAKE="1.6"

src_unpack(){
	unpack ${A}
	cd ${S}
	#./autogen.sh
	 sed -i -e"s:-mcpu=i486::g" configure
}

src_compile() {
	econf `use_enable sdl`			\
		  `use_enable gtk gui`		\
		  --enable-optimize=none 	\
		  || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
