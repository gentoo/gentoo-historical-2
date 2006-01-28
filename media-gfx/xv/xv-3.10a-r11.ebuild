# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xv/xv-3.10a-r11.ebuild,v 1.14 2006/01/28 21:05:07 blubb Exp $

inherit flag-o-matic eutils toolchain-funcs

JUMBOV=20050410
DESCRIPTION="An interactive image manipulation program for X which can deal with a wide variety of image formats"
HOMEPAGE="http://www.trilon.com/xv/index.html http://www.sonic.net/~roelofs/greg_xv.html"
SRC_URI="mirror://sourceforge/png-mng/${P}-jumbo-patches-${JUMBOV}.tar.bz2 ftp://ftp.cis.upenn.edu/pub/xv/${P}.tar.gz"

LICENSE="xv"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc-macos ppc64 sparc x86"
IUSE="jpeg tiff png"

DEPEND="virtual/x11
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.6.1-r2 )
	png? ( >=media-libs/libpng-1.2 >=sys-libs/zlib-1.1.4 )"

src_unpack() {
	unpack ${A}

	cd ${S}

	epatch ${WORKDIR}/${P}-jumbo-fix-patch-${JUMBOV}.txt || die
	epatch ${WORKDIR}/${P}-jumbo-enh-patch-${JUMBOV}.txt || die

	# various security issues.
	epatch ${FILESDIR}/${P}-bmpfix.patch || die
	epatch ${FILESDIR}/${P}-yaos.diff || die

	if use ppc-macos; then
		epatch ${FILESDIR}/${PF}-xv-osx.patch
		epatch ${FILESDIR}/${P}-vdcomp-osx.patch
	fi

	sed -i	-e 's/\(^JPEG.*\)/#\1/g' \
			-e 's/\(^PNG.*\)/#\1/g' \
			-e 's/\(^TIFF.*\)/#\1/g' \
			-e 's/\(^LIBS = .*\)/\1 $(LDFLAGS) /g' Makefile

	# /usr/bin/gzip => /bin/gzip
	sed -i	-e 's#/usr\(/bin/gzip\)#\1#g' config.h

}

src_compile() {
	if use ppc-macos; then
		append-flags -DUSE_GETCWD -DUSLEEP
	else
		append-flags -DUSE_GETCWD -DLINUX -DUSLEEP
	fi

	einfo "Enabling Optional Features..."
	if use jpeg; then
		ebegin "	jpeg"
			append-flags -DDOJPEG
			append-ldflags -ljpeg
		eend
	fi
	if use png; then
		ebegin "	png"
			append-flags -DDOPNG
			append-ldflags -lz -lpng
		eend
	fi
	if use tiff; then
		ebegin "	tiff"
			append-flags -DDOTIFF -DUSE_TILED_TIFF_BOTLEFT_FIX
			append-ldflags -ltiff
		eend
	fi
	einfo "done."

	emake CC="$(tc-getCC)" CCOPTS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	emake	DESTDIR=${D} \
			BINDIR=${D}/usr/bin \
			MANDIR=${D}/usr/share/man/man1 \
			LIBDIR=${T} install || die

	dodoc README{,.jumbo,.pcd} INSTALL CHANGELOG BUGS IDEAS docs/*.ps docs/*.doc
}
