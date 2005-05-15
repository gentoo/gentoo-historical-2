# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.0.1-r2.ebuild,v 1.16 2005/05/15 02:18:30 flameeyes Exp $

inherit libtool flag-o-matic toolchain-funcs

DESCRIPTION="the Ogg Vorbis sound file format library"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
SRC_URI="http://www.vorbis.com/files/${PV}/unix/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ~ppc-macos sparc x86"
IUSE=""

RDEPEND=">=media-libs/libogg-1.0"
DEPEND="${RDEPEND}
	sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix a gcc crash.  With the new atexit patch to gcc, it
	# seems it does not handle -mno-ieee-fp very well.
	sed -i -e "s:-mno-ieee-fp::g" configure
}

src_compile() {
	# Fixes some strange sed-, libtool- and ranlib-errors on
	# Mac OS X
	if use ppc-macos; then
		glibtoolize
	else
		elibtoolize
	fi

	# Cannot compile with sse2 support it would seem #36104
	use x86 && [ $(gcc-major-version) -eq 3 ] && append-flags -mno-sse2

	# take out -fomit-frame-pointer from CFLAGS if k6-2
	is-flag -march=k6-3 && filter-flags -fomit-frame-pointer
	is-flag -march=k6-2 && filter-flags -fomit-frame-pointer
	is-flag -march=k6 && filter-flags -fomit-frame-pointer

	# over optimization causes horrible audio artifacts #26463
	filter-flags -march=pentium?

	# gcc on hppa causes issues when assembling
	use hppa && replace-flags -march=2.0 -march=1.0

	# Make prelink work properly
	append-flags -fPIC
	append-ldflags -fPIC

	econf || die
	use ppc-macos && cd ${S} && sed -i -e 's/examples//' Makefile
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	if use ppc-macos; then
		dosym /usr/lib/libvorbisfile.3.1.0.dylib /usr/lib/libvorbisfile.0.dylib
		dosym /usr/lib/libvorbisenc.2.0.0.dylib /usr/lib/libvorbisenc.0.dylib
	else
		dosym /usr/lib/libvorbisfile.so.3.1.0 /usr/lib/libvorbisfile.so.0
		dosym /usr/lib/libvorbisenc.so.2.0.0 /usr/lib/libvorbisenc.so.0
	fi

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README todo.txt
	docinto txt
	dodoc doc/*.txt
	dohtml -r doc
}
