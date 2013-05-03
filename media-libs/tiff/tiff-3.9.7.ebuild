# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.9.7.ebuild,v 1.3 2013/05/03 11:13:39 ago Exp $

EAPI=5

# this ebuild is only for the libtiff.so.3 (+ 4) and libtiffxx.so.3 (+ 4) SONAME for ABI compat

inherit eutils libtool multilib

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${P}.tar.gz"

LICENSE="libtiff"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx jbig jpeg zlib"

RDEPEND="jpeg? ( virtual/jpeg )
	jbig? ( media-libs/jbigkit )
	zlib? ( sys-libs/zlib )
	!media-libs/tiff-compat
	!=media-libs/tiff-3*:0"
DEPEND="${RDEPEND}"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--libdir=/libdir \
		--disable-static \
		$(use_enable cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		--without-x
}

src_install() {
	# Let `make install` and libtool handle insecure runpath(s)
	dodir tmp
	emake DESTDIR="${ED}/tmp" install

	# .so.3 (upstream) is used by sci-chemistry/icm
	# .so.4 (Debian) is used by net-im/skype
	exeinto /usr/$(get_libdir)
	doexe "${ED}"/tmp/libdir/libtiff$(get_libname 3)
	dosym libtiff$(get_libname 3) /usr/$(get_libdir)/libtiff$(get_libname 4)
	if use cxx; then
		doexe "${ED}"/tmp/libdir/libtiffxx$(get_libname 3)
		dosym libtiffxx$(get_libname 3) /usr/$(get_libdir)/libtiffxx$(get_libname 4)
	fi

	rm -rf "${ED}"/tmp
}
