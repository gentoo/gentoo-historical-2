# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.0.ebuild,v 1.5 2002/12/09 04:26:13 manson Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="the Ogg Vorbis sound file format library"
SRC_URI="http://fatpipe.vorbis.com/files/1.0/unix/${P}.tar.gz"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"

DEPEND=">=media-libs/libogg-1.0"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc "

src_unpack() {
	unpack ${A}

	cd ${S}
	# Fix a gcc crash.  With the new atexit patch to gcc, it
	# seems it do not handle -mno-ieee-fp too well.
	cp configure configure.orig
	sed -e "s:-mno-ieee-fp::g" \
		configure.orig >configure
}

src_compile() {
	elibtoolize

	export CFLAGS="${CFLAGS/-march=*/}"

	./configure --prefix=/usr \
		--host=${CHOST} || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	echo "Removing docs installed by make install"
	rm -rf ${D}/usr/share/doc

	dodoc AUTHORS COPYING README todo.txt
	docinto txt
	dodoc doc/*.txt
	dohtml -r doc
}

pkg_postinst() {
	einfo 
	einfo "Note the 1.0 version of libvorbis has been installed"
	einfo "Applications that used pre-1.0 vorbis libraries will"
	einfo "need to be recompiled for the new version."
	einfo "Now that the vorbis folks have finalized the API"
	einfo "this should be the last time for a while that"
	einfo "recompilation is needed for these things."
	einfo
}
