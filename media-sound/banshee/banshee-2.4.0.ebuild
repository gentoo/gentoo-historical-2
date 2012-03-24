# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/banshee/banshee-2.4.0.ebuild,v 1.1 2012/03/24 10:11:30 pacho Exp $

EAPI="4"

inherit eutils autotools mono gnome2-utils fdo-mime versionator gnome.org

DESCRIPTION="Import, organize, play, and share your music using a simple and powerful interface."
HOMEPAGE="http://banshee.fm/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aac +cdda +bpm boo daap doc +encode ios karma mtp test udev +web youtube"

RDEPEND=">=dev-lang/mono-2.4.3
	gnome-base/gnome-settings-daemon
	x11-themes/gnome-icon-theme
	sys-apps/dbus
	>=dev-dotnet/gtk-sharp-2.12:2
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
	>=media-libs/gstreamer-0.10.21-r3:0.10
	>=media-libs/gst-plugins-base-0.10.25.2:0.10
	media-libs/gst-plugins-bad
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-ugly:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	media-plugins/gst-plugins-gio:0.10
	>=dev-dotnet/gconf-sharp-2.24.0:2
	media-plugins/gst-plugins-gconf:0.10
	cdda? (
		|| (
			media-plugins/gst-plugins-cdparanoia:0.10
			media-plugins/gst-plugins-cdio:0.10
		)
	)
	media-libs/musicbrainz:1
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	>=dev-dotnet/mono-addins-0.4[gtk]
	>=dev-dotnet/taglib-sharp-2.0.3.7
	>=dev-db/sqlite-3.4:3
	karma? ( >=media-libs/libkarma-0.1.0-r1 )
	aac? ( media-plugins/gst-plugins-faad:0.10 )
	boo? ( >=dev-lang/boo-0.8.1 )
	bpm? ( media-plugins/gst-plugins-soundtouch:0.10 )
	daap? (	>=dev-dotnet/mono-zeroconf-0.8.0-r1 )
	doc? (
		virtual/monodoc
		>=app-text/gnome-doc-utils-0.17.3
	)
	encode? (
		media-plugins/gst-plugins-lame:0.10
		media-plugins/gst-plugins-taglib:0.10
	)
	ios? (
		>=media-libs/libgpod-0.7.95[mono]
		gnome-base/gvfs[ios]
	)
	mtp? (
		>=media-libs/libmtp-0.3.0
	)
	web? (
		>=net-libs/webkit-gtk-1.2.2:2
		>=net-libs/libsoup-2.26:2.4
		>=net-libs/libsoup-gnome-2.26:2.4
	)
	youtube? (
		>=dev-dotnet/google-gdata-sharp-1.4
	)
	udev? (
		dev-dotnet/gudev-sharp
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
		dev-dotnet/gio-sharp
	)"

DEPEND="${RDEPEND}
	app-arch/xz-utils
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_prepare () {
	# Don't build BPM extension when not wanted
	if ! use bpm; then
		sed -i -e 's:Banshee.Bpm:$(NULL):g' src/Extensions/Makefile.am || die
		AT_M4DIR="-I build/m4/banshee -I build/m4/shamrock -I build/m4/shave" \
		eautoreconf
	fi
}

src_configure() {
	# soundmenu needs a properly maintained and updated indicate-sharp
	local myconf="--disable-dependency-tracking
		--disable-static
		--disable-maintainer-mode
		--enable-gnome
		--enable-schemas-install
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--enable-gapless-playback
		--disable-gst-sharp
		--disable-torrent
		--disable-shave
		--disable-ubuntuone
		--disable-soundmenu
		--disable-upnp"

	econf \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
		$(use_enable boo) \
		$(use_enable mtp) \
		$(use_enable daap) \
		$(use_enable ios appledevice) \
		$(use_enable karma) \
		$(use_enable web webkit) \
		$(use_enable youtube) \
		$(use_enable udev gio) \
		$(use_enable udev gio_hardware) \
		${myconf}
}

src_compile() {
	emake MCS=/usr/bin/gmcs
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -name '*.la' -exec rm -f {} +
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	ewarn
	ewarn "If ${PN} doesn't play some format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
