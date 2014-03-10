# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-extra/mate-character-map/mate-character-map-1.6.0.ebuild,v 1.2 2014/03/10 13:06:01 ssuominen Exp $

EAPI="5"

GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

PYTHON_COMPAT=( python2_{6,7} )

inherit autotools gnome2 python-r1 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cjk +introspection test"

RDEPEND="dev-libs/atk:0
	>=dev-libs/glib-2.16.3:2
	x11-libs/cairo:0
	>=x11-libs/pango-1.2.1:0
	>=x11-libs/gtk+-2.14:2
	virtual/libintl:0
	introspection? ( >=dev-libs/gobject-introspection-0.6:0 )"

DEPEND="${RDEPEND}
	app-text/rarian
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	>=app-text/mate-doc-utils-1.6:0
	test? ( app-text/docbook-xml-dtd:4.1.2 )"

src_prepare() {
	# Fix test
	sed -i 's/gucharmap/mucharmap/g' po/POTFILES.in || die

	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-gtk=2.0 \
		--disable-python-bindings \
		$(use_enable introspection) \
		$(use_enable cjk unihan)
}

DOCS="ChangeLog NEWS README TODO"
