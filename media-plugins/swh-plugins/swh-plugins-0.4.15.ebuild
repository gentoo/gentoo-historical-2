# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/swh-plugins/swh-plugins-0.4.15.ebuild,v 1.2 2007/06/29 15:38:25 flameeyes Exp $

WANT_AUTOMAKE="1.8"

inherit eutils autotools

DESCRIPTION="Large collection of LADSPA audio plugins/effects"
HOMEPAGE="http://plugin.org.uk"
SRC_URI="http://plugin.org.uk/releases/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86"
IUSE="3dnow nls sse userland_Darwin"

RDEPEND="media-libs/ladspa-sdk
	>=sci-libs/fftw-3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-pic.patch"
	epatch "${FILESDIR}/${P}-plugindir.patch"
	epatch "${FILESDIR}/${P}-riceitdown.patch"

	# This is needed to run autoreconf with newer autotools
	sed -i -e 's:@MKINSTALLDIRS@:$(top_srcdir)/mkinstalldirs:' \
		po/Makefile.in.in || die "mkinstalldirs sed failed"

	eautoreconf
	elibtoolize
}

src_compile() {
	econf ${myconf} \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable nls) \
		$(use_enable userland_Darwin darwin) \
		--enable-fast-install \
		--disable-dependency-tracking || die "econf failed"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst() {
	ewarn "WARNING: You have to be careful when using the"
	ewarn "swh plugins. Be sure to lower your sound volume"
	ewarn "and then play around a bit with the plugins so"
	ewarn "you get a feeling for it. Otherwise your speakers"
	ewarn "won't like that."
}
