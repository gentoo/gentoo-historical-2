# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.12.0.ebuild,v 1.2 2006/03/24 16:21:15 foser Exp $

inherit eutils gnome2 autotools

DESCRIPTION="Xft powered terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc python opengl"

RDEPEND=">=dev-libs/glib-2.0
	>=x11-libs/gtk+-2.2
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
	|| ( x11-libs/libX11 virtual/x11 )
	virtual/xft"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.0 )
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {

	G2CONF="$(use_enable debug debugging) \
		$(use_enable python) \
		$(use_enable opengl glX) \
		--with-xft2
		--with-pangox"

}

src_unpack() {

	unpack ${A}
	cd ${S}

	# Resolve all symbols at execution time for gnome-pty-helper. See bug
	# #91617.
	epatch ${FILESDIR}/${PN}-no_lazy_bindings.patch

	cd "${S}/gnome-pty-helper"
	eautoreconf || die "eautoreconf failed"

}
