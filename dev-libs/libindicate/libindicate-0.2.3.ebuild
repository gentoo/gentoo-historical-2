# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicate/libindicate-0.2.3.ebuild,v 1.3 2009/10/30 00:02:59 scarabeus Exp $

EAPI=2

inherit autotools eutils versionator

DESCRIPTION="Library to raise flags on DBus for other components of the desktop to pick up and visualize"
HOMEPAGE="https://launchpad.net/libindicate/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk doc"
# They put their mother in the tarball ? ^^
RESTRICT="test"

RDEPEND="dev-libs/glib:2
	>=dev-libs/dbus-glib-0.76
	dev-libs/libxml2:2
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	dev-util/pkgconfig"
src_prepare() {
	# Make libindicator-gtk library optional
	epatch "${FILESDIR}/${P}-optional-gtk-support.patch"
	# Drop -Werror in a release
	sed -e 's:-Werror::g' -i libindicate/Makefile.in || die "sed failed"
	eautoreconf
}
src_configure() {
	# gobject-instrospection is a nightmare in this package, it's fixable for libindicate
	# and not for libindicate-gtk, disable it until its fixed on upstream
	econf --disable-dependency-tracking \
		--disable-gobject-introspection \
		$(use_enable gtk) \
		$(use_enable doc)
}
src_test() {
	emake check || die "testsuite failed"
}
src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS || die "dodoc failed"
}
