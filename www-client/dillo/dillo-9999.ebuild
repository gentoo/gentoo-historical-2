# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-9999.ebuild,v 1.1 2009/04/10 15:57:12 yngwin Exp $

EAPI="2"
inherit eutils multilib mercurial

DESCRIPTION="Lean FLTK2-based web browser"
HOMEPAGE="http://www.dillo.org/"
EHG_REPO_URI="http://hg.dillo.org/dillo"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc +gif ipv6 +jpeg +png ssl"

RDEPEND="x11-libs/fltk:2[-cairo,jpeg=,png=]
	sys-libs/zlib
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/dillo2-inbuf.patch
	./autogen.sh
}

src_configure() {
	LDFLAGS="${LDFLAGS} -L/usr/$(get_libdir)/fltk" \
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

	elog "Dillo has installed a default configuration into /etc/dillorc"
	elog "You can copy this to ~/.dillo/ and customize it"
}
