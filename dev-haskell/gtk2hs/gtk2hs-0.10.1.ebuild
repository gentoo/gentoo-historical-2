# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/gtk2hs/gtk2hs-0.10.1.ebuild,v 1.1 2009/08/30 09:50:50 kolmodin Exp $

EAPI="2"

inherit base eutils ghc-package multilib toolchain-funcs versionator

DESCRIPTION="A GUI Library for Haskell based on Gtk+"
HOMEPAGE="http://haskell.org/gtk2hs/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~sparc ~ppc ~x86"

IUSE="doc profile glade gnome opengl svg seamonkey xulrunner"

RDEPEND=">=dev-lang/ghc-6.6
		dev-haskell/mtl
		x11-libs/gtk+:2
		glade? ( gnome-base/libglade )
		gnome? ( gnome-base/libglade
				>=x11-libs/gtksourceview-2.2
				gnome-base/gconf )
		svg?   ( gnome-base/librsvg )
		opengl? ( x11-libs/gtkglext )
		xulrunner? ( =net-libs/xulrunner-1.8* )
		seamonkey? ( =www-client/seamonkey-1* )"

DEPEND="${RDEPEND}
		doc? ( >=dev-haskell/haddock-2.4.1 )
		dev-util/pkgconfig"

MY_P="${P/%_rc*}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--enable-gtk \
		--enable-packager-mode \
		$(version_is_at_least "4.2" "$(gcc-version)" && \
			echo --disable-split-objs) \
		$(has_version '>=x11-libs/gtk+-2.8' && echo --enable-cairo) \
		$(use glade || use gnome && echo --enable-libglade) \
		$(use_enable gnome gconf) \
		$(use_enable gnome gtksourceview2) \
		$(use_enable svg svg) \
		$(use_enable opengl opengl) \
		--disable-firefox \
		$(use_enable seamonkey seamonkey) \
		$(use_enable xulrunner xulrunner) \
		$(use_enable doc docs) \
		$(use_enable profile profiling) \
		|| die "Configure failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {

	make install \
		DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		haddockifacedir="/usr/share/doc/${PF}" \
		|| die "Make install failed"

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
			"${D}/usr/$(get_libdir)/gtk2hs/gtksourceview2.package.conf" ) \
		$(use svg && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/svgcairo.package.conf") \
		$(use opengl && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/gtkglext.package.conf") \
		$(use seamonkey || use xulrunner && echo \
			"${D}/usr/$(get_libdir)/gtk2hs/mozembed.package.conf")
	ghc-install-pkg
}
