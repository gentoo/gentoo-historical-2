# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.14.1.ebuild,v 1.15 2007/11/02 04:25:20 mr_bones_ Exp $

inherit eutils gnome2 autotools python

DESCRIPTION="Xft powered terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug doc python opengl"

RDEPEND=">=dev-libs/glib-2.9
	>=x11-libs/gtk+-2.6
	>=x11-libs/pango-1.1
	>=media-libs/freetype-2.0.2
	media-libs/fontconfig
	sys-libs/ncurses
	python? (
		>=dev-python/pygtk-2.4
		>=dev-lang/python-2.2
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)
	x11-libs/libX11
	virtual/xft"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.0 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="$(use_enable debug debugging) $(use_enable python) \
			$(use_with opengl glX) --with-xft2 --with-pangox"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}/${PN}-0.13.2-no-lazy-bindings.patch"
	epatch "${FILESDIR}/${P}-fbsd.patch"

	cd "${S}/gnome-pty-helper"
	eautomake
}

pkg_postinst() {
	if use python; then
		python_version
		python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0"
	fi
}

pkg_postrm() {
	if use python; then
		python_version
		python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0"
	fi
}
