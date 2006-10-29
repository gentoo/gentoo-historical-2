# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gle/gle-3.1.0-r1.ebuild,v 1.3 2006/10/29 23:41:16 flameeyes Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.4"

inherit autotools multilib

# Using method from media-libs/mesa.

DESCRIPTION="GL extrusion library"
HOMEPAGE="http://www.linas.org/gle"
SRC_URI="http://www.linas.org/gle/pub/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

DEPEND="virtual/opengl
	virtual/glu
	virtual/glut
	app-admin/eselect-opengl"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Replace inclusion of malloc.h with stdlib.h as needed by Mac OS X and
	# FreeBSD. See bug #130340.
	sed -i -e 's:malloc.h:stdlib.h:g' src/*

	# Don't build binary examples as they never get installed. See bug 141859.
	sed -i -e 's:examples::' Makefile.am
	eautoreconf
}

src_compile() {
	econf --with-x \
		--x-libraries=/usr/$(get_libdir)/opengl/xorg-x11 \
		|| die "econf failed."

	emake || die "emake failed."
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
	dodoc AUTHORS ChangeLog NEWS README
	use doc || rm -rf "${D}"/usr/share/doc/gle
}
