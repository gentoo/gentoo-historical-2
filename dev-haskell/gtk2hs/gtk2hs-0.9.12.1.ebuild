# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/gtk2hs/gtk2hs-0.9.12.1.ebuild,v 1.4 2008/01/20 18:56:57 angelos Exp $

inherit base eutils ghc-package multilib toolchain-funcs versionator

DESCRIPTION="A GUI Library for Haskell based on Gtk+"
HOMEPAGE="http://haskell.org/gtk2hs/"
SRC_URI="mirror://sourceforge/gtk2hs/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"

IUSE="doc glade gnome opengl svg firefox seamonkey profile xulrunner"

RDEPEND=">=dev-lang/ghc-6.4
		dev-haskell/mtl
		>=x11-libs/gtk+-2
		glade? ( >=gnome-base/libglade-2 )
		gnome? ( >=gnome-base/libglade-2
				<x11-libs/gtksourceview-2.0
				>=gnome-base/gconf-2 )
		svg?   ( >=gnome-base/librsvg-2.16 )
		opengl? ( x11-libs/gtkglext )
		seamonkey? ( >=www-client/seamonkey-1.0.2 )
		firefox? ( >=www-client/mozilla-firefox-1.0.4 )
		xulrunner? ( net-libs/xulrunner )"
DEPEND="${RDEPEND}
		doc? ( >=dev-haskell/haddock-0.8 )"

src_compile() {
	econf \
		--enable-packager-mode \
		$(version_is_at_least "4.2" "$(gcc-version)" && \
			echo --disable-split-objs) \
		$(has_version '>=x11-libs/gtk+-2.8' && echo --enable-cairo) \
		$(use glade || use gnome && echo --enable-libglade) \
		$(use_enable gnome gconf) \
		$(use_enable gnome sourceview) \
		$(use_enable svg svg) \
		$(use_enable opengl opengl) \
		$(use_enable seamonkey seamonkey) \
		$(use_enable firefox firefox) \
		$(use_enable xulrunner xulrunner) \
		$(use_enable doc docs) \
		$(use_enable profile profiling) \
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
	ghc-setup-pkg \
		"${D}/usr/$(get_libdir)/gtk2hs/glib.package.conf" \
		$(has_version '>=x11-libs/gtk+-2.8' && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/cairo.package.conf") \
		"${D}/usr/$(get_libdir)/gtk2hs/gtk.package.conf" \
		"${D}/usr/$(get_libdir)/gtk2hs/soegtk.package.conf" \
		$(use glade || use gnome && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/glade.package.conf") \
		$(use gnome && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/gconf.package.conf" \
			"${D}/usr/$(get_libdir)/gtk2hs/sourceview.package.conf" ) \
		$(use svg && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/svgcairo.package.conf") \
		$(use opengl && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/gtkglext.package.conf") \
		$(use seamonkey || use firefox || use xulrunner && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/mozembed.package.conf")
	ghc-install-pkg
}
