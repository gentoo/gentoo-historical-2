# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Michael Cohen <mjc@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/gogo/gogo-3.10.ebuild,v 1.1 2002/05/30 04:54:55 mjc Exp $

S=${WORKDIR}/gogo-${PV}
DESCRIPTION="GoGo is an assembly optimized version of LAME 3.91"
SRC_URI="http://member.nifty.ne.jp/~pen/free/gogo3/down/petit310pl3.tgz"
HOMEPAGE="http://member.nifty.ne.jp/~pen/free/gogo3/mct_gogo.htm"

DEPEND="virtual/glibc
	dev-lang/nasm"
#	>=sys-libs/ncurses-5.H2
#	gtk?    ( =x11-libs/gtk+-1.2* )"
#	oggvorbis? ( >=media-libs/libvorbis-1.0_rc3 )"
# Oggvorbis support breaks with -rc3 
RDEPEND="virtual/glibc"
#	>=sys-libs/ncurses-5.2
#	gtk?    ( =x11-libs/gtk+-1.2* )"
#	oggvorbis? ( >=media-libs/libvorbis-1.0_rc3 )"

src_unpack() {
	unpack ${A}
	cd petit310pl3
}

src_compile() {

	local myconf=""
#	if [ "`use oggvorbis`" ] ; then
#		myconf="--with-vorbis"
		myconf="--without-vorbis"
#	else
#		myconf="--without-vorbis"
#	fi
#	if [ "`use gtk`" ] ; then
#		myconf="$myconf --enable-mp3x"
#	fi
	if [ "$DEBUG" ] ; then
		myconf="$myconf --enable-debug=yes"
	else
		myconf="$myconf --enable-debug=no"
	fi
	
	cd /var/tmp/portage/gogo-${PV}/work/petit310pl3
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--enable-shared \
		--enable-nasm \
		--enable-extopt=full \
		$myconf || die
		
	emake || die
}

src_install () {

	cd /var/tmp/portage/gogo-${PV}/work/petit310pl3
	patch -p0 < ${FILESDIR}/make-work-3.10pl3.patch || die
	mkdir ${D}/usr
	mkdir ${D}/usr/bin
	mkdir ${D}/usr/share
	mkdir ${D}/usr/share/man
	mkdir ${D}/usr/share/doc
	make exec_prefix=${D}usr \
		mandir=${D}usr/share/man \
		install || die

	dodoc API COPYING HACKING PRESETS.draft LICENSE README* TODO USAGE
	dohtml -r ./
}
