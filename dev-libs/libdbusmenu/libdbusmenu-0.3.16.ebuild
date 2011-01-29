# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu/libdbusmenu-0.3.16.ebuild,v 1.1 2011/01/29 15:58:13 tampakrap Exp $

EAPI=3

inherit autotools eutils versionator

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/dbusmenu/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk +introspection test"

# Needs running dbus and a program called "dbus-test-runner"
RESTRICT="test"

RDEPEND="dev-libs/glib:2
	dev-libs/dbus-glib
	dev-libs/libxml2:2
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
    introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	test? ( dev-libs/json-glib[introspection=] )
	dev-util/intltool
	dev-util/pkgconfig"

src_prepare() {
	# Make libdbusmenu-gtk library optional, launchpad-bug #552530
	epatch "${FILESDIR}/${P}-optional-gtk.patch"
	# Make tests optional, launchpad-bug #552526
	epatch "${FILESDIR}/${P}-optional-tests.patch"
	# Try to make parallel-make safe, launchpad-bug #709762
	epatch "${FILESDIR}/${P}-parallel-make.patch"
	# Decouple testapp from libdbusmenu-gtk, launchpad-bug #709761
	epatch "${FILESDIR}/${P}-decouple-testapp.patch"
	# Make dbusmenudumper optional, launchpad-bug #643871
	epatch "${FILESDIR}/${PN}-0.3.14-optional-dumper.patch"
	# Fixup undeclared HAVE_INTROSPECTION, launchpad-bug #552538
	epatch "${FILESDIR}/${PN}-0.3.14-fix-aclocal.patch"
	# Drop -Werror in a release
	sed -e 's:-Werror::g' -i libdbusmenu-glib/Makefile.am libdbusmenu-gtk/Makefile.am || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk) \
		$(use_enable gtk dumper) \
		$(use_enable introspection) \
		$(use_enable test tests)
}

src_test() {
	emake check || die "testsuite failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS || die "dodoc failed"
}
