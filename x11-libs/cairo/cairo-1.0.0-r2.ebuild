# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/cairo/cairo-1.0.0-r2.ebuild,v 1.1 2005/09/02 15:58:45 leonardop Exp $

inherit eutils

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc glitz png static X"

RDEPEND="media-libs/fontconfig
	>=media-libs/freetype-2.1
	sys-libs/zlib
	X? (
		||(	(
			x11-libs/libXrender
			x11-libs/libX11
			x11-libs/libXt )
			virtual/x11 )
		virtual/xft )
	glitz? ( >=media-libs/glitz-0.4.4 )
	png? ( media-libs/libpng )
	!<x11-libs/cairo-0.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? (
		>=dev-util/gtk-doc-1.3
		~app-text/docbook-xml-dtd-4.2 )"


src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Fix segmentation fault when compiling with -fomit-frame-pointer.
	# See bug #104265.
	epatch ${FILESDIR}/${P}-omit_frame_pointer_fix.patch

	# Upstream patch to correctly handle displays which don't match the local
	# endianness. https://bugs.freedesktop.org/show_bug.cgi?id=4321
	epatch ${FILESDIR}/${P}-display_endianness.patch

	# Fix some tests that were failing on amd64.
	# https://bugs.freedesktop.org/show_bug.cgi?id=4245
	epatch ${FILESDIR}/${P}-tests.patch
}

src_compile() {
	local myconf="$(use_enable X xlib) \
		$(use_with X x)           \
		$(use_enable png)         \
		$(use_enable static)      \
		$(use_enable doc gtk-doc) \
		$(use_enable glitz)"

	econf $myconf || die "./configure failed"
	emake || die "Compilation failed"
}


src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
