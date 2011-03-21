# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/seed/seed-2.30.0.ebuild,v 1.2 2011/03/21 23:03:02 nirbheek Exp $

EAPI="2"

inherit autotools gnome2

DESCRIPTION="Javascript bindings for Webkit-GTK and GNOME libraries"
HOMEPAGE="http://live.gnome.org/Seed"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus debug doc mpfr profile +sqlite test +xml"

# XXX: We need gcc at runtime for the seed profile-module
# XXX: Seed ships javascript extensions that rdepend on clutter[introspection],
#      gstreamer[introspection], gnome-js-common, etc. Haven't expressing them
#      here yet. We should do that once USE=introspection is unmasked,
#      gnome-js-common enters tree, gstreamer gets introspection support, etc.
RDEPEND="
	>=dev-libs/gobject-introspection-0.6.3

	dev-libs/glib:2
	virtual/libffi
	dev-libs/dbus-glib
	x11-libs/cairo
	x11-libs/gtk+:2
	net-libs/webkit-gtk:2

	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib )
	mpfr? ( dev-libs/mpfr )
	profile? ( sys-devel/gcc )
	sqlite? ( dev-db/sqlite:3 )
	xml? ( dev-libs/libxml2:2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-0.9 )
	test? (
		dev-libs/gobject-introspection
		x11-libs/pango[introspection]
		x11-libs/gtk+:2[introspection]
		gnome-base/gconf:2[introspection] )"
DOCS="AUTHORS ChangeLog NEWS README"
# FIXME: tests need gconf introspection support, which is in 2.28 branch
#        upstream (no releases), and in 2.31 releases
# FIXME: tests need all the feature-USE-flags enabled to complete successfully
RESTRICT="test"

src_prepare() {
	G2CONF="${G2CONF}
		$(use_enable dbus dbus-module)
		$(use_enable mpfr mpfr-module)
		$(use_enable sqlite sqlite-module)
		$(use_enable xml libxml-module)"

	# configure behaves very strangely and enables profiling if we pass either
	# --disable-profile or --enable-profile
	if use profile; then
		G2CONF="${G2CONF}
			--enable-profile
			--enable-profile-modules"
		if ! use debug; then
			elog "USE=profile needs debug, auto-enabling..."
			G2CONF="${G2CONF} --enable-debug"
		fi
	fi

	if use profile && has ccache ${FEATURES}; then
		ewarn "USE=profile behaves very badly with ccache; it tries to create"
		ewarn "profiling data in CCACHE_DIR. Please disable one of them!"
	fi

	# Hard-code gnome-js-common module install path to avoid circular dep
	epatch "${FILESDIR}/${PN}-fix-gnome-js-common-circular-dep.patch"

	# Uhm. autotools.eclass failure
	mkdir m4
	eautoreconf
}
