# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter-gtk/clutter-gtk-1.0.4.ebuild,v 1.3 2012/01/14 17:25:51 maekke Exp $

EAPI="4"
GCONF_DEBUG="yes"
CLUTTER_LA_PUNT="yes"

# inherit clutter after gnome2 so that defaults aren't overriden
inherit gnome2 clutter gnome.org

DESCRIPTION="Clutter-GTK - GTK+3 Integration library for Clutter"

SLOT="1.0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc examples +introspection"

# XXX: Needs gtk with X support (!directfb)
RDEPEND="
	>=x11-libs/gtk+-3:3[introspection?]
	>=media-libs/clutter-1.4:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gettext-0.18
	doc? ( >=dev-util/gtk-doc-1.14 )"

pkg_setup() {
	DOCS="NEWS README"
	EXAMPLES="examples/{*.c,redhand.png}"
	G2CONF="${G2CONF}
		--with-flavour=x11
		--enable-maintainer-flags=no
		$(use_enable introspection)"
}
