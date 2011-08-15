# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-3.0.2.ebuild,v 1.1 2011/08/15 12:26:09 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Nautilus"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="doc exif gnome +introspection sendto xmp"

COMMON_DEPEND=">=dev-libs/glib-2.28.0:2
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.0.8:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3.0.0:3

	gnome-base/gsettings-desktop-schemas
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	xmp? ( >=media-libs/exempi-2.1.0 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.4 )"
RDEPEND="${COMMON_DEPEND}
	sendto? ( !gnome-extra/nautilus-sendto )"
# For eautoreconf
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am"
PDEPEND="gnome? (
		>=x11-themes/gnome-icon-theme-1.1.91
		x11-themes/gnome-icon-theme-symbolic )
	>=gnome-base/gvfs-0.1.2"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-update-mimedb
		--disable-packagekit
		$(use_enable exif libexif)
		$(use_enable introspection)
		$(use_enable sendto nst-extension)
		$(use_enable xmp)"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS TODO"
}

src_prepare() {
	# Gentoo bug #365779 + https://bugzilla.gnome.org/show_bug.cgi?id=651209
	epatch "${FILESDIR}/${PN}-3.0.2-segfault-in-gtk_icon_info_load_symbolic.patch"

	gnome2_src_prepare

	# Remove crazy CFLAGS
	sed 's:-DG.*DISABLE_DEPRECATED::g' -i configure.in configure \
		|| die "sed 1 failed"
}

src_test() {
	addpredict "/root/.gnome2_private"
	unset SESSION_MANAGER
	unset ORBIT_SOCKETDIR
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "nautilus can use gstreamer to preview audio files. Just make sure"
	elog "to have the necessary plugins available to play the media type you"
	elog "want to preview"
}
