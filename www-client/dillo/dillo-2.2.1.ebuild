# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-2.2.1.ebuild,v 1.1 2011/08/01 15:38:08 patrick Exp $

EAPI="2"
inherit eutils flag-o-matic multilib

DESCRIPTION="Lean FLTK2-based web browser"
HOMEPAGE="http://www.dillo.org/"
SRC_URI="http://www.dillo.org/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +gif ipv6 +jpeg +png ssl"

RDEPEND="x11-libs/fltk:2[-cairo,jpeg=,png=]
	sys-libs/zlib
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/dillo2-inbuf.patch
}

src_configure() {
	append-ldflags "-L/usr/$(get_libdir)/fltk"
	econf  \
		$(use_enable gif) \
		$(use_enable ipv6) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable ssl)
}

src_compile() {
	emake || die "make failed"
	if use doc ; then
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	dodir /etc
	emake DESTDIR="${D}" install || die "install failed"

	if use doc; then
		dohtml html/* || die "install documentation failed"
	fi
	dodoc AUTHORS ChangeLog README NEWS
	docinto doc
	dodoc doc/*.txt doc/README

	doicon "${FILESDIR}"/dillo.png
	make_desktop_entry dillo Dillo dillo
}

pkg_postinst() {
	elog "Dillo has installed a default configuration into /etc/dillo/dillorc"
	elog "You can copy this to ~/.dillo/ and customize it"
}
