# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-0.6.0_pre5-r1.ebuild,v 1.1 2002/05/26 18:16:55 azarah Exp $

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="video stream processing tool"
SRC_URI="http://www.theorie.physik.uni-goettingen.de/~ostreich/transcode/pre/${MY_P}.tgz"
HOMEPAGE="http://www.theorie.physik.uni-goettingen.de/~ostreich/transcode"

# Note: transcode can use pretty much any media-related package ever written as
# a plugin. An exhaustive dep list would make me add about 20-30 packages to 
# portage. perhaps another time :-)

DEPEND=">=media-libs/a52dec-0.7.3
	media-libs/libdv
	media-libs/libsdl
	dev-lang/nasm
	=x11-libs/gtk+-1.2*
	X? ( virtual/x11 )
	avi? ( >=media-video/avifile-0.7.4 )
	dvd? ( media-libs/libdvdread )
	mpeg? ( media-libs/libmpeg3 )
	encode? ( >=media-sound/lame-3.89 )
	quicktime? ( media-libs/quicktime4linux )"

src_unpack() {
	unpack ${A}

	[ -z "${CC}" ] && CC="gcc"
	if [ "`${CC} --version | cut -f1 -d.`" = "3" ];
	then
		patch -p0 < ${FILESDIR}/${P}.diff || die
	fi
}

src_compile() {

	# fix invalid paths in .la files of plugins
	libtoolize --copy --force

	local myconf=""

	use mmx \
		&& myconf="${myconf} --enable-mmx"
	use mmx || ( use 3dnow || use sse ) \
		|| myconf="${myconf} --disable-mmx"
	# Dont disable mmx if 3dnow or sse are requested.

	use sse \
		&& myconf="${myconf} --enable-sse" \
		|| myconf="${myconf} --disable-sse"

	use avi \
		&& myconf="${myconf} --enable-avifile6" \
		|| myconf="${myconf} --disable-avifile6"

	use dvd \
		&& myconf="${myconf} --enable-dvdread" \
		|| myconf="${myconf} --disable-dvdread"
	
	use encode \
		&& myconf="${myconf} --with-lame" \
		|| myconf="${myconf} --without-lame"
	
	use mpeg \
		&& myconf="${myconf} --with-libmpeg3" \
		|| myconf="${myconf} --without-libmpeg3"

	use quicktime \
		|| myconf="${myconf} --without-qt --without-openqt"

	use X \
		&& myconf="${myconf} --enable-x" \
		|| myconf="${myconf} --disable-x"
	
	econf ${myconf} || die

	emake all || die

}

src_install () {

	make \
		DESTDIR=${D} \
		install || die
}

