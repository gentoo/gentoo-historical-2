# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/orpheus/orpheus-1.2.ebuild,v 1.6 2004/09/04 01:10:35 swegener Exp $

DESCRIPTION="Command line MP3 player."
HOMEPAGE="http://konst.org.ua/en/orpheus"
SRC_URI="http://konst.org.ua/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"
LICENSE="GPL-2"
IUSE="oggvorbis"

DEPEND=">=sys-libs/ncurses-5.2
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta1 )
	virtual/mpg123
	media-sound/vorbis-tools
	gnome-base/libghttp"
#	nas? ( >=media-libs/nas-1.4.1 )

src_unpack() {
	unpack ${A}

	#if use nas; then
	#	cd src
	#	sed -e "s:^INCLUDES =:INCLUDES = -I/usr/X11R6/include:" \
	#		-e "s:^splay_LDADD =:splay_LDADD = \$(NAS_LIBS):" \
	#		Makefile | cat > Makefile
	#fi
}

src_compile() {
	local myconf
	### Looks like NAS support is broken, at least with NAS 1.5 and
	### mp3player 3.1.1 (Aug 13, agenkin@thpoon.com)
	#use nas && myconf="${myconf} --with-nas"
	#use nas || myconf="${myconf} --disable-nas"
	myconf="${myconf}"

	econf ${myconf} || die
	make CC="gcc ${CFLAGS}" CXX="c++ ${CXXFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
