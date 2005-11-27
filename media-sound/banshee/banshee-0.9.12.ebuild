# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/banshee/banshee-0.9.12.ebuild,v 1.1 2005/11/27 20:11:12 metalgod Exp $

inherit eutils gnome2 mono

DESCRIPTION="Banshee allows you to import CDs, sync your music collection to an
iPod, play music directly from an iPod."
HOMEPAGE="http://banshee-project.org"
SRC_URI="http://banshee-project.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac flac mad real vorbis"

RDEPEND=">=dev-lang/mono-1.1.9.2
	>=dev-dotnet/gtk-sharp-2.3.90
	>=dev-dotnet/gnomevfs-sharp-1.9
	>=dev-dotnet/gconf-sharp-2.3.90
	>=media-libs/gstreamer-0.8.11
	>=media-libs/gst-plugins-0.8.11
	>=media-plugins/gst-plugins-gnomevfs-0.8.11
	mad? ( >=media-plugins/gst-plugins-mad-0.8.11 )
	vorbis? ( >=media-plugins/gst-plugins-ogg-0.8.11
		>=media-plugins/gst-plugins-vorbis-0.8.11 )
	flac? ( >=media-plugins/gst-plugins-flac-0.8.11 )
	aac? ( >=media-plugins/gst-plugins-faad-0.8.11
		>=media-libs/faad2-2.0-r4 )
	>=media-libs/musicbrainz-2.1.1
	real? ( media-video/realplayer )
	>=dev-libs/glib-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/gnome-desktop-2.0
	>=dev-dotnet/ipod-sharp-0.5.10
	>=sys-apps/hal-0.5.2
	sys-apps/dbus
	>=dev-db/sqlite-3
	>=gnome-extra/nautilus-cd-burner-2.12"

USE_DESTDIR=1
DOCS="ChangeLog NEWS README TODO"

pkg_setup() {
	if ! built_with_use sys-apps/dbus mono ; then
		echo
		eerror "In order to compile banshee, you need to have sys-apps/dbus emerged"
		eerror "with 'mono' in your USE flags. Please add that flag, re-emerge"
		eerror "dbus, and then emerge banshee."
		die "sys-apps/dbus is missing the .NET binding."
	fi
	if use real; then
		G2CONF="${G2CONF} --enable-helix --with-helix-libs=/opt/RealPlayer/"
	fi
	G2CONF="${G2CONF} --disable-xing"
}

src_compile() {
	gnome2_src_configure
	emake -j1 || "compile failed"
}
