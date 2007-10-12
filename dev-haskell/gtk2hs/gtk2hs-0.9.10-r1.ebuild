# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/gtk2hs/gtk2hs-0.9.10-r1.ebuild,v 1.5 2007/10/12 08:41:45 remi Exp $

inherit base eutils ghc-package multilib autotools

DESCRIPTION="A GUI Library for Haskell based on Gtk+"
HOMEPAGE="http://haskell.org/gtk2hs/"
SRC_URI="mirror://sourceforge/gtk2hs/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
#enable sparc when CFLAGS/-mcpu ebuild bug is fixed

IUSE="doc glade gnome firefox"

RDEPEND="<virtual/ghc-6.6
		!>=virtual/ghc-6.6
		amd64? ( || ( >=dev-lang/ghc-6.4.1 >=dev-lang/ghc-bin-6.4.1 ) )
		>=x11-libs/gtk+-2
		glade? ( >=gnome-base/libglade-2 )
		gnome? ( >=gnome-base/libglade-2
				 =x11-libs/gtksourceview-1*
				 >=gnome-base/gconf-2 )
		firefox? ( >=www-client/mozilla-firefox-1.0.4 )"
DEPEND="${RDEPEND}
		doc? ( >=dev-haskell/haddock-0.7 )"

src_unpack() {
	base_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.9.10-cflags.patch"
	epatch "${FILESDIR}/${PN}-0.9.10-ghc622.patch"
	epatch "${FILESDIR}/${PN}-0.9.10-store.patch"
}

src_compile() {
	# only needed because of the cflags patch above.
	eautoreconf

	econf \
		--enable-packager-mode \
		$(has_version '>=x11-libs/gtk+-2.8' && echo --enable-cairo) \
		$(use glade || use gnome && echo --enable-libglade) \
		$(use_enable gnome gconf) \
		$(use_enable gnome sourceview) \
		$(use_enable firefox firefox) \
		$(use_enable doc docs) \
		|| die "Configure failed"

	# parallel build doesn't work, so specify -j1
	emake -j1 || die "Make failed"
}

src_install() {

	make install \
		DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		haddockifacedir="/usr/share/doc/${PF}" \
		|| die "Make install failed"

	# for some reason it creates the doc dir even if it is configured
	# to not generate docs, so lets remove the empty dirs in that case
	# (and lets be cautious and only remove them if they're empty)
	if ! use doc; then
		rmdir "${D}/usr/share/doc/${PF}/html"
		rmdir "${D}/usr/share/doc/${PF}"
		rmdir "${D}/usr/share/doc"
		rmdir "${D}/usr/share"
	fi

	# arrange for the packages to be registered
	if ghc-cabal; then
		pkgext=package.conf
	else
		pkgext=pkg
	fi
	ghc-setup-pkg \
		"${D}/usr/$(get_libdir)/gtk2hs/glib.${pkgext}" \
		$(has_version '>=x11-libs/gtk+-2.8' && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/cairo.${pkgext}") \
		"${D}/usr/$(get_libdir)/gtk2hs/gtk.${pkgext}" \
		"${D}/usr/$(get_libdir)/gtk2hs/mogul.${pkgext}" \
		$(use glade || use gnome && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/glade.${pkgext}") \
		$(use gnome && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/gconf.${pkgext}" \
			"${D}/usr/$(get_libdir)/gtk2hs/sourceview.${pkgext}") \
		$(use firefox && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/mozembed.${pkgext}")
	ghc-install-pkg

	# build ghci .o files from .a files
	ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSglib.a"
	if has_version '>=x11-libs/gtk+-2.8'; then
		ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHScairo.a"
	fi
	ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSgtk.a"
	ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSmogul.a"
	if use glade || use gnome; then
		ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSglade.a"
	fi
	if use gnome; then
		ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSgconf.a"
		ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSsourceview.a"
	fi
	if use firefox; then
		ghc-makeghcilib "${D}/usr/$(get_libdir)/gtk2hs/libHSmozembed.a"
	fi
}
