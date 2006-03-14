# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/banshee/banshee-0.10.8.ebuild,v 1.1 2006/03/14 21:46:00 metalgod Exp $

inherit eutils gnome2 mono

DESCRIPTION="Banshee allows you to import CDs, sync your music collection, play
music directly from an iPod, create playlists with songs from your library, and
create audio and MP3 CDs from subsets of your library."
HOMEPAGE="http://banshee-project.org"
SRC_URI="http://banshee-project.org/files/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac doc daap ipod flac mad njb vorbis"

RDEPEND=">=dev-lang/mono-1.1.13
	>=dev-dotnet/gtk-sharp-2.8.0
	>=dev-dotnet/gnomevfs-sharp-2.8.0
	>=dev-dotnet/gconf-sharp-2.8.0
	>=media-libs/gstreamer-0.10.0
	>=media-libs/gst-plugins-good-0.10.0
	>=media-plugins/gst-plugins-gnomevfs-0.10.0
	>=media-plugins/gst-plugins-gconf-0.10.0
	mad? ( >=media-plugins/gst-plugins-mad-0.10.0 )
	vorbis? ( >=media-plugins/gst-plugins-ogg-0.10.0
		>=media-plugins/gst-plugins-vorbis-0.10.0 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.0 )
	aac? ( >=media-plugins/gst-plugins-faad-0.10.0
		>=media-libs/faad2-2.0-r4 )
	>=media-plugins/gst-plugins-cdparanoia-0.10.0
	>=media-libs/musicbrainz-2.1.1
	real? ( media-video/realplayer )
	njb? ( >=dev-dotnet/njb-sharp-0.2.2 )
	daap? ( >=net-dns/avahi-0.6.4 )
	>=dev-libs/glib-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/gnome-desktop-2.0
	ipod? ( >=dev-dotnet/ipod-sharp-0.5.15 )
	>=sys-apps/hal-0.5.2
	>=sys-apps/dbus-0.60
	>=dev-db/sqlite-3
	>=gnome-extra/nautilus-cd-burner-2.12"

USE_DESTDIR=1
DOCS="ChangeLog HACKING NEWS README"

pkg_setup() {
	if ! built_with_use sys-apps/dbus mono ; then
		echo
		eerror "In order to compile banshee, you need to have sys-apps/dbus emerged"
		eerror "with 'mono' in your USE flags. Please add that flag, re-emerge"
		eerror "dbus, and then emerge banshee."
		die "sys-apps/dbus is missing the .NET binding."
	fi

	if ! built_with_use net-dns/avahi mono ; then
		echo
		eerror "In order to compile banshee with daap support"
		eerror "you need to have net-dns/avahi emerged"
		eerror "with 'mono' in your USE flags. Please add that flag, re-emerge"
		eerror "avahi, and then emerge banshee."
		die "net-dns/avahi is missing the .NET binding."
	fi

	if use daap; then
		G2CONF="${G2CONF} --enable-avahi"
		else
		G2CONF="${G2CONF} --disable-daap"
	fi

	G2CONF="${G2CONF} --disable-xing \
		--disable-helix \
		--disable-docs \
		--with-gstreamer-0-10 \
		$( use_enable ipod) \
		$( use_enable njb)"
}

src_compile() {
	addpredict "/root/.gconf/"
	addpredict "/root/.gconfd"
	gnome2_src_configure
	emake -j1 || "make failed"
}

src_install() {
	gnome2_src_install
	if ! use ipod; then
		dodir /usr/$(get_libdir)/banshee/Banshee.Dap
	fi
}
pkg_postinst() {
	einfo "In case you have an ipod please rebuild this package with USE=ipod"
	einfo "If you have a audio player supported by libnjb please"
	einfo "rebuild this package with USE=njb"
	einfo
	einfo "Banshee is build only with gstreamer 0.10.x support."
	einfo
}
