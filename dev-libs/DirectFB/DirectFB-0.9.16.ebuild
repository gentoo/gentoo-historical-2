# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/DirectFB/DirectFB-0.9.16.ebuild,v 1.2 2003/02/13 10:32:19 vapier Exp $

DESCRIPTION="thin library on top of the Linux framebuffer devices"
SRC_URI="http://www.directfb.org/download/DirectFB/${P}.tar.gz"
HOMEPAGE="http://www.directfb.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="gif quicktime mpeg png truetype flash jpeg mmx sse sdl"

DEPEND="sys-devel/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mpeg? ( media-libs/libmpeg3 )
	flash? ( >=media-libs/libflash-0.4.10 )
	truetype? ( >=media-libs/freetype-2.0.1 )
	quicktime? ( media-libs/quicktime4linux )"
#	avi? ( >=media-video/avifile-0.7.4.20020426-r2 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp configure configure.orig
	sed -e 's:ac_safe=`echo "libmpeg3.h:ac_safe=`echo "libmpeg3/libmpeg3.h:' \
		-e 's:#include <libmpeg3.h>:#include <libmpeg3/libmpeg3.h>:' \
		configure.orig > configure
}

src_compile() {
	local myconf=""
	
	# Bug in the ./configure script that breaks if you
	# have --enable-mmx
	use mmx \
		&& myconf="${myconf} --enable-mmx" \
		|| myconf="${myconf} --disable-mmx"

	use sse \
		&& myconf="${myconf} --enable-sse" \
		|| myconf="${myconf} --disable-sse"

# Still do not work currently
#	use avi	\
#		&& myconf="${myconf} --enable-avifile" \
#		|| myconf="${myconf} --disable-avifile"
	myconf="${myconf} --disable-avifile"
	
	use mpeg \
		&& myconf="${myconf} --enable-libmpeg3" \
		|| myconf="${myconf} --disable-libmpeg3"
	
	use sdl \
		&& myconf="${myconf} --enable-sdl" \
		|| myconf="${myconf} --disable-sdl"

	use flash \
		&& myconf="${myconf} --enable-flash" \
		|| myconf="${myconf} --disable-flash"

	use jpeg \
		&& myconf="${myconf} --enable-jpeg" \
		|| myconf="${myconf} --disable-jpeg"

	use png \
		&& myconf="${myconf} --enable-png" \
		|| myconf="${myconf} --disable-png"

	use gif \
		&& myconf="${myconf} --enable-gif" \
		|| myconf="${myconf} --disable-gif"

	use truetype \
		&& myconf="${myconf} --enable-freetype" \
		|| myconf="${myconf} --disable-freetype"

	# fix gcc3.x linking with libflash
	cp configure configure.old
	sed -e 's:-lflash:-lflash -lstdc++:' configure.old > configure
	econf ${myconf}

	use mpeg && ( \
		cd ${S}/interfaces/IDirectFBVideoProvider
		cp idirectfbvideoprovider_libmpeg3.c \
			idirectfbvideoprovider_libmpeg3.c.orig
	
		sed s':#include <libmpeg3.h>:#include <libmpeg3/libmpeg3.h>:' \
			idirectfbvideoprovider_libmpeg3.c.orig > \
				idirectfbvideoprovider_libmpeg3.c
		cd ${S}
	)

	# add extra -lstdc++ so libpng/libflash link correctly
	make LDFLAGS="${LDFLAGS} -lstdc++" || die
}

src_install() {
	insinto /etc
	doins fb.modes

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README* TODO
	dohtml -r docs/html
}
