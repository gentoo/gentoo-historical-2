# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/lame/lame-3.91.ebuild,v 1.1 2002/01/06 00:03:03 azarah Exp $

S=${WORKDIR}/lame-${PV}
DESCRIPTION="LAME Ain't an Mp3 Encoder"
SRC_URI="http://download.sourceforge.net/lame/${P}.tar.gz"
HOMEPAGE="http://www.mp3dev.org/mp3/"

DEPEND="virtual/glibc
	dev-lang/nasm
	>=sys-libs/ncurses-5.2
	gtk?    ( >=x11-libs/gtk+-1.2.10-r4 )"
#	vorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

RDEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	gtk?    ( >=x11-libs/gtk+-1.2.10-r4 )"
#	vorbis? ( >=media-libs/libvorbis-1.0_beta4 )"


src_compile() {

	local myconf=""
	if [ "`use vorbis`" ] ; then
	#	myconf="--with-vorbis"
		myconf="--without-vorbis"
	else
		myconf="--without-vorbis"
	fi
	if [ "`use gtk`" ] ; then
		myconf="$myconf --enable-mp3x"
	fi
	if [ "$DEBUG" ] ; then
		myconf="$myconf --enable-debug=yes"
	else
		myconf="$myconf --enable-debug=no"
	fi
	
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--enable-shared \
		--enable-nasm \
		--enable-mp3rtp \
		--enable-extopt=full \
		$myconf || die
		
	emake || die
}

src_install () {

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		pkghtmldir=${D}/usr/share/doc/${PF}/html \
		install || die

	dodoc API COPYING HACKING PRESETS.draft LICENSE README* TODO USAGE
	docinto html
}

