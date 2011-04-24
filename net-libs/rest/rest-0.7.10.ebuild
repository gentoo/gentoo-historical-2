# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rest/rest-0.7.10.ebuild,v 1.1 2011/04/24 12:02:30 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="http://git.gnome.org/browse/librest"

LICENSE="LGPL-2.1"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gnome +introspection test"

# XXX: coverage testing should not be enabled
RDEPEND=">=dev-libs/glib-2.18:2
	dev-libs/libxml2:2
	net-libs/libsoup:2.4

	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.13 )
	test? ( sys-apps/dbus )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-gcov
		$(use_with gnome)
		$(use_enable introspection)"
	DOCS="AUTHORS NEWS README"
}

src_prepare() {
	# Conditional patching because the test passes without libsoup
	if use test && use gnome; then
		# https://bugs.meego.com/show_bug.cgi?id=16650
		epatch "${FILESDIR}/${P}-disable-broken-test.patch"
	fi
	gnome2_src_prepare
}

src_test() {
	# Tests need dbus
	Xemake check || die
}
