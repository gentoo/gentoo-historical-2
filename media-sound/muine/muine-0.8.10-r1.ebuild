# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muine/muine-0.8.10-r1.ebuild,v 1.3 2009/09/27 16:35:35 nixnut Exp $

EAPI=2

inherit base gnome2 mono eutils multilib flag-o-matic

DESCRIPTION="A music player for GNOME"
HOMEPAGE="http://muine-player.org"
SRC_URI="http://download.gnome.org/sources/muine/0.8/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="flac mad vorbis xine"

RDEPEND="x11-themes/gnome-icon-theme
	>=dev-lang/mono-2
	>=x11-libs/gtk+-2.6
	>=dev-dotnet/gtk-sharp-2.12.9
	>=dev-dotnet/glade-sharp-2.12.6
	>=dev-dotnet/gnome-sharp-2.6
	>=dev-dotnet/gconf-sharp-2.6
	>=dev-dotnet/gnomevfs-sharp-2.6
	>=dev-dotnet/dbus-sharp-0.4
	>=dev-dotnet/dbus-glib-sharp-0.3
	sys-libs/gdbm
	>=media-libs/flac-1.1.2
	>=media-libs/libvorbis-1
	>=media-libs/libid3tag-0.15.0b
	xine? ( >=media-libs/xine-lib-1 )
	!xine? (
		=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-base-0.10*
		=media-libs/gst-plugins-good-0.10*
		=media-plugins/gst-plugins-gconf-0.10*
		=media-plugins/gst-plugins-gnomevfs-0.10*
		flac? ( =media-plugins/gst-plugins-flac-0.10* )
		mad? ( =media-plugins/gst-plugins-mad-0.10* )
		vorbis? ( =media-plugins/gst-plugins-ogg-0.10*
			=media-plugins/gst-plugins-vorbis-0.10* )
	)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper
	gnome-base/gnome-common
	>=dev-util/intltool-0.29
	virtual/monodoc"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS PLUGINS README TODO"

PATCHES=(
	"${FILESDIR}/${P}-buttons.patch"
	"${FILESDIR}/${P}-gtk-sharp-2.12.9.patch"
	)

# The build is not parallel safe
MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	gnome2_src_unpack
}

src_prepare() {
	base_src_prepare

}

src_configure() {
	gnome2_src_configure --enable-compile-warnings=yes --disable-faad2  $(use_enable xine)
}

src_compile() {
	default
}

src_install() {
	gnome2_src_install
	insinto /usr/$(get_libdir)/${PN}/plugins
	doins "${S}"/plugins/TrayIcon.dll
}

pkg_postinst() {
	elog
	elog "Upstream no longer packages the tray icon plugin by default."
	elog "The Gentoo ebuilds will continue to install the plugin, if you don't"
	elog "want to use the plugin, remove TrayIcon.dll from"
	elog "/usr/$(get_libdir)/muine/plugins/"
	elog
}
