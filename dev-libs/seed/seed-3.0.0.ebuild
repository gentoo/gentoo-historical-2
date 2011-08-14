# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/seed/seed-3.0.0.ebuild,v 1.1 2011/08/14 15:19:36 nirbheek Exp $

EAPI="3"
WANT_AUTOMAKE="1.11"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Javascript bindings for Webkit-GTK and GNOME libraries"
HOMEPAGE="http://live.gnome.org/Seed"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc profile test"

RDEPEND="
	>=dev-libs/gobject-introspection-0.9

	dev-libs/glib:2
	virtual/libffi
	x11-libs/cairo
	x11-libs/gtk+:3[introspection]
	net-libs/webkit-gtk:3
	gnome-base/gnome-js-common
	dev-db/sqlite:3
	dev-libs/dbus-glib
	dev-libs/mpfr
	dev-libs/libxml2:2
	sys-apps/dbus
	sys-libs/readline"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-0.9 )
	profile? ( sys-devel/gcc )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--with-webkit=3.0
		--enable-readline-module
		--enable-os-module
		--enable-ffi-module
		--enable-gtkbuilder-module
		--enable-cairo-module
		--enable-gettext-module
		--enable-dbus-module
		--enable-mpfr-module
		--enable-sqlite-module
		--enable-libxml-module"

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
}

#src_prepare() {
	# I've no idea what abcd did here; the patch doesn't apply anymore (nirbheek)
#	epatch "${FILESDIR}/${PN}-2.31.5-cleanup-autotools.patch"
#
#	intltoolize --automake --copy --force || die "intltoolize failed"
#	eautoreconf
#}
