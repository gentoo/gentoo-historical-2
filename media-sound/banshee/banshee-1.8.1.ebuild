# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/banshee/banshee-1.8.1.ebuild,v 1.7 2011/03/24 11:41:21 hwoarang Exp $

EAPI=2

inherit eutils autotools mono gnome2-utils fdo-mime versionator

GVER=0.10.7

DESCRIPTION="Import, organize, play, and share your music using a simple and powerful interface."
HOMEPAGE="http://banshee.fm/"

#BANSHEE_V2=$(get_version_component_range 2)
#[[ $((${BANSHEE_V2} % 2)) -eq 0 ]] && RELTYPE=stable || RELTYPE=unstable
#SRC_URI="http://download.banshee-project.org/${PN}/${RELTYPE}/${PV}/${PN}-1-${PV}.tar.bz2"
SRC_URI="http://download.banshee-project.org/${PN}/stable/${PV}/${PN}-1-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+aac +cdda boo daap doc +encode ipod karma mtp podcast test udev +web youtube"

RDEPEND=">=dev-lang/mono-2.4.3
	gnome-base/gnome-settings-daemon
	x11-themes/gnome-icon-theme
	sys-apps/dbus
	>=dev-dotnet/gtk-sharp-2.12:2
	>=dev-dotnet/gconf-sharp-2.24.0:2
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
	>=media-libs/gstreamer-0.10.21-r3:0.10
	>=media-libs/gst-plugins-base-0.10.25.2:0.10
	>=media-libs/gst-plugins-bad-${GVER}
	>=media-libs/gst-plugins-good-${GVER}:0.10
	>=media-libs/gst-plugins-ugly-${GVER}:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gnomevfs-${GVER}:0.10
	>=media-plugins/gst-plugins-gconf-${GVER}:0.10
	cdda? (
		|| (
			>=media-plugins/gst-plugins-cdparanoia-${GVER}:0.10
			>=media-plugins/gst-plugins-cdio-${GVER}:0.10
		)
	)
	media-libs/musicbrainz:1
	>=dev-dotnet/ndesk-dbus-glib-0.4.1
	>=dev-dotnet/ndesk-dbus-0.6.1a
	>=dev-dotnet/mono-addins-0.4[gtk]
	>=dev-dotnet/taglib-sharp-2.0.3.7
	>=dev-db/sqlite-3.4:3
	karma? ( >=media-libs/libkarma-0.1.0-r1 )
	aac? ( >=media-plugins/gst-plugins-faad-${GVER}:0.10 )
	boo? (
		>=dev-lang/boo-0.8.1
	)
	daap? (
		>=dev-dotnet/mono-zeroconf-0.8.0-r1
	)
	doc? (
		virtual/monodoc
		>=app-text/gnome-doc-utils-0.17.3
	)
	encode? (
		>=media-plugins/gst-plugins-lame-${GVER}:0.10
		>=media-plugins/gst-plugins-taglib-${GVER}:0.10
	)
	ipod? (
		>=media-libs/libgpod-0.7.95[mono]
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
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

S=${WORKDIR}/${PN}-1-${PV}

src_prepare () {
	epatch "${FILESDIR}/${PN}-1.7.4-make-webkit-optional.patch"
	AT_M4DIR="-I build/m4/banshee -I build/m4/shamrock -I build/m4/shave" \
		eautoreconf
}

src_configure() {
	local myconf="--disable-dependency-tracking
		--disable-static
		--enable-gnome
		--enable-schemas-install
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--enable-gapless-playback
		--disable-gst-sharp
		--disable-hal
		--disable-torrent
		--disable-shave"

	econf \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
		$(use_enable boo) \
		$(use_enable mtp) \
		$(use_enable daap) \
		$(use_enable ipod appledevice) --disable-ipod \
		$(use_enable podcast) \
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
	emake DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -exec rm -f {} +
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
