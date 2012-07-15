# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libchamplain/libchamplain-0.12.3.ebuild,v 1.1 2012/07/15 23:10:07 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"

LICENSE="LGPL-2"
SLOT="0.12"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc +gtk +introspection vala"

REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=x11-libs/cairo-1.4
	>=media-libs/clutter-1.2:1.0[introspection?]
	>=media-libs/memphis-0.2.1:0.2[introspection?]
	>=net-libs/libsoup-gnome-2.4.1:2.4
	dev-db/sqlite:3
	gtk? (
		>=x11-libs/gtk+-2.90:3[introspection?]
		>=media-libs/clutter-gtk-0.90:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	vala? ( >=dev-lang/vala-0.14.2-r1:0.14[vapigen] )"
# segfaults with vala:0.12
# vala-0.14.2-r1 required for bug #402013

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	# Vala demos are only built, so just disable them
	G2CONF="${G2CONF}
		--disable-static
		--disable-maemo
		--disable-vala-demos
		--enable-memphis
		VAPIGEN=$(type -p vapigen-0.14)
		$(use_enable debug)
		$(use_enable gtk)
		$(use_enable introspection)
		$(use_enable vala)"
}

src_prepare() {
	# Fix documentation slotability
	sed -e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-${SLOT}/" \
		-i docs/reference/Makefile.{am,in} || die "sed (1) failed"
	sed -e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-gtk-${SLOT}/" \
		-i docs/reference-gtk/Makefile.{am,in} || die "sed (2) failed"
	mv "${S}"/docs/reference/${PN}{,-${SLOT}}-docs.sgml || die "mv (1) failed"
	mv "${S}"/docs/reference-gtk/${PN}-gtk{,-${SLOT}}-docs.sgml || die "mv (2) failed"

	gnome2_src_prepare
}
