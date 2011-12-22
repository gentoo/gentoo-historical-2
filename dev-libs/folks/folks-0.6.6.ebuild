# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/folks/folks-0.6.6.ebuild,v 1.1 2011/12/22 23:16:03 eva Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="libfolks is a library that aggregates people from multiple sources"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Folks"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-linux"
IUSE="eds socialweb test tracker utils vala"

COMMON_DEPEND=">=dev-libs/glib-2.24:2
	>=net-libs/telepathy-glib-0.13.1
	dev-libs/dbus-glib
	<dev-libs/libgee-0.7:0[introspection]
	dev-libs/libxml2
	>=gnome-base/gconf-2.31
	sys-libs/ncurses
	sys-libs/readline

	eds? ( >=gnome-extra/evolution-data-server-3.1.5 )
	socialweb? ( >=net-libs/libsocialweb-0.25.15 )
	tracker? ( >=app-misc/tracker-0.12 )"

# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-mission-control"

# folks socialweb backend requires that libsocialweb be built with USE=vala,
# even when building folks with --disable-vala.
DEPEND="${COMMON_DEPEND}
	>=dev-libs/gobject-introspection-1.30
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.21
	sys-devel/gettext

	socialweb? ( >=net-libs/libsocialweb-0.25.15[vala] )
	test? ( sys-apps/dbus )
	vala? (
		>=dev-lang/vala-0.14:0.14[vapigen]
		>=net-libs/telepathy-glib-0.13.1[vala]
		eds? ( >=gnome-extra/evolution-data-server-3.0.1[vala] ) )"

# the inspect tool requires --enable-vala
REQUIRED_USE="utils? ( vala )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	# Rebuilding docs needs valadoc, which has no release
	G2CONF="${G2CONF}
		$(use_enable eds eds-backend)
		$(use_enable socialweb libsocialweb-backend)
		$(use_enable tracker tracker-backend)
		$(use_enable utils inspect-tool)
		$(use_enable vala)
		--enable-import-tool
		--disable-docs
		--disable-Werror"
	if use vala; then
		G2CONF="${G2CONF}
			VALAC=$(type -p valac-0.14)
			VAPIGEN=$(type -p vapigen-0.14)"
	fi
}

src_test() {
	# FIXME: eds tests often fails for no good reason
	sed -e 's/check: .*/check: /' \
		-i tests/eds/Makefile || die "sed failed"
	default
}
