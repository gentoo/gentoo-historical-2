# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-3.6.1.ebuild,v 1.1 2012/12/16 13:02:34 eva Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="dbus debug djvu dvi gnome-keyring +introspection nautilus +postscript t1lib tiff xps"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"
fi

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
# atk used in libview
# gdk-pixbuf used all over the place
# libX11 used for totem-screensaver
RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.33:2
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
	>=x11-libs/cairo-1.10
	>=app-text/poppler-0.20[cairo]
	djvu? ( >=app-text/djvu-3.5.17 )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea
		t1lib? ( >=media-libs/t1lib-5 ) )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22 )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	nautilus? ( >=gnome-base/nautilus-2.91.4[introspection?] )
	postscript? ( >=app-text/libspectre-0.2.0 )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.2.1 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.3
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools
		doc? ( >=dev-util/gtk-doc-1.13 )"
fi

ELTCONF="--portage"

# Needs dogtail and pyspi from http://fedorahosted.org/dogtail/
# Releases: http://people.redhat.com/zcerza/dogtail/releases/
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-tests
		--enable-pdf
		--enable-comics
		--enable-thumbnailer
		--with-smclient=xsmp
		--with-platform=gnome
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome-keyring keyring)
		$(use_enable introspection)
		$(use_enable nautilus)
		$(use_enable postscript ps)
		$(use_enable t1lib)
		$(use_enable tiff)
		$(use_enable xps)"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	# Fix .desktop file so menu item shows up
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch

	# Fix .desktop file categories, in 3.7
	epatch "${FILESDIR}/${PN}-3.6.0-evince.desktop.patch"

	gnome2_src_prepare
	# Do not depend on gnome-icon-theme, bug #326855, #391859
	sed -e 's/gnome-icon-theme >= $GNOME_ICON_THEME_REQUIRED//g' \
		-i configure || die "sed failed"
}
