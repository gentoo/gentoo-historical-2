# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/totem-pl-parser/totem-pl-parser-2.32.3.ebuild,v 1.1 2011/02/21 19:16:26 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://projects.gnome.org/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc quvi +introspection"

RDEPEND=">=dev-libs/glib-2.24:2
	dev-libs/gmime:2.4
	>=net-libs/libsoup-gnome-2.30:2.4
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	quvi? ( >=media-libs/quvi-0.2.11 )"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.11 )"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.11

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable quvi)
		$(use_enable introspection)"
	DOCS="AUTHORS ChangeLog NEWS"
}

src_prepare() {
	gnome2_src_prepare

	# Disable tests requiring network access, bug #346127
	sed -e 's:\(g_test_add_func.*/parser/resolution.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/parser/parsing/itms_link.*\):/*\1*/:' \
		-i plparse/tests/parser.c || die "sed failed"
}

src_test() {
	# This is required as told by upstream in bgo#629542
	dbus-launch emake check || die "emake check failed"
}
