# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mlt/mlt-20051209.ebuild,v 1.3 2006/01/09 22:22:21 mr_bones_ Exp $

DESCRIPTION="MLT is an open source multimedia framework, designed and developed
for television broadcasting"
HOMEPAGE="http://mlt.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dv xml2 jack gtk sdl vorbis sox quicktime"

DEPEND="media-video/ffmpeg
		dv?		( >=media-libs/libdv-0.102 )
		xml2?	( >=dev-libs/libxml2-2.5 )
		vorbis?	( >=media-libs/libvorbis-1.0.1 )
		sdl?	( >=media-libs/libsdl-1.2
				  media-libs/sdl-image )
		media-libs/libsamplerate
		jack?	( media-sound/jack-audio-connection-kit
				  >=dev-libs/libxml2-2.5 )
		gtk?	( >=x11-libs/gtk+-2.0
				  x11-libs/pango )
		sox? 	( media-sound/sox )
		quicktime? ( media-libs/libquicktime )
		"

src_compile() {
	local myconf=""
	if ! use dv ; 		then myconf="${myconf} --disable-dv"
	fi
	if ! use gtk ; 		then myconf="${myconf} --disable-gtk2"
	fi
	if ! use xml2 ; 	then myconf="${myconf} --disable-westley"
	fi
	if ! use vorbis ; 	then myconf="${myconf} --disable-vorbis"
	fi
	if ! use sdl ; 		then myconf="${myconf} --disable-sdl"
	fi
	if ! use jack ; 	then myconf="${myconf} --disable-jackrack"
	fi
	if ! use sox ; 		then myconf="${myconf} --disable-sox"
	fi
	if ! use quicktime || !use dv ; then myconf="${myconf} --disable-kino"
	fi

	./configure --prefix=/usr \
				--enable-gpl \
				--enable-motion-est \
				--disable-xine \
				--avcodec-shared=/usr \
				${myconf}
	emake
}

src_install() {
	make DESTDIR="${D}" install
	dodoc -r docs
	insinto /usr/share/mlt
	doins -r demo
}

