# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib/imlib-1.9.14-r3.ebuild,v 1.9 2005/04/29 00:03:13 vapier Exp $

inherit gnome.org libtool eutils

DESCRIPTION="general image loading and rendering library"
HOMEPAGE="http://developer.gnome.org/arch/imaging/imlib.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/tiff-3.5.5
	>=media-libs/giflib-4.1.0
	>=media-libs/libpng-1.2.1
	>=media-libs/jpeg-6b"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix config script #3425
	sed -i \
		-e "49,51D" \
		-e "55,57D" \
		imlib-config.in

	# Security fix per bug #62487
	epatch "${FILESDIR}"/${P}-bound.patch
	#Security fix for bug #72681
	epatch "${FILESDIR}"/${P}-sec2.patch
	# shutup aclocal
	epatch "${FILESDIR}"/${P}-m4.patch

	elibtoolize
}

src_compile() {
	econf --sysconfdir=/etc/imlib || die
	emake || die
}

src_install() {
	einstall \
		includedir="${D}"/usr/include \
		sysconfdir="${D}"/etc/imlib \
		|| die
	preplib /usr

	dodoc AUTHORS ChangeLog README NEWS
	dohtml -r doc
}
