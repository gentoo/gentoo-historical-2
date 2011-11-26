# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-3.2.1.ebuild,v 1.3 2011/11/26 02:45:45 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus debug djvu doc dvi gnome-keyring +introspection nautilus t1lib tiff xps"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
# atk used in libview
# gdk-pixbuf used all over the place
# libX11 used for totem-screensaver
RDEPEND="
	>=app-text/libspectre-0.2.0
	dev-libs/atk
	>=dev-libs/glib-2.25.11:2
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0.2:3[introspection?]
	x11-libs/libX11
	>=x11-libs/libSM-1
	x11-libs/libICE
	gnome-base/gsettings-desktop-schemas
	|| (
		>=x11-themes/gnome-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
	>=x11-libs/cairo-1.10.0
	>=app-text/poppler-0.16[cairo]
	djvu? ( >=app-text/djvu-3.5.17 )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea
		t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )
	nautilus? ( >=gnome-base/nautilus-2.91.4[introspection?] )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.0.1 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13
	doc? ( >=dev-util/gtk-doc-1.13 )"

ELTCONF="--portage"

# Needs dogtail and pyspi from http://fedorahosted.org/dogtail/
# Releases: http://people.redhat.com/zcerza/dogtail/releases/
RESTRICT="test"

pkg_setup() {
	# Passing --disable-help would drop offline help, that would be inconsistent
	# with helps of the most of Gnome apps that doesn't require network for that.
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--disable-tests
		--enable-pdf
		--enable-comics
		--enable-thumbnailer
		--with-smclient=xsmp
		--with-platform=gnome
		--enable-help
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome-keyring keyring)
		$(use_enable introspection)
		$(use_enable nautilus)
		$(use_enable t1lib)
		$(use_enable tiff)
		$(use_enable xps)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	# Fix .desktop file so menu item shows up
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch

	gnome2_src_prepare

	# Do not depend on gnome-icon-theme, bug #326855, #391859
	sed -e 's/gnome-icon-theme >= $GNOME_ICON_THEME_REQUIRED//g' \
		-i configure || die "sed failed"
}
