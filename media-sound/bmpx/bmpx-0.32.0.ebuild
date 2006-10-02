# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bmpx/bmpx-0.32.0.ebuild,v 1.1 2006/10/02 19:29:25 chutzpah Exp $

inherit fdo-mime eutils

DESCRIPTION="Next generation Beep Media Player"
HOMEPAGE="http://www.beep-media-player.org"
SRC_URI="http://files.beep-media-player.org/releases/0.30/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="aac alsa cdparanoia debug flac ffmpeg gaim hal mad musepack nls ofa ogg oss raptor sid theora vorbis"

RDEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.8.8
	>=x11-libs/pango-1.10.0
	dev-libs/boost
	app-arch/zip
	>=dev-cpp/glibmm-2.8.3
	>=dev-cpp/gtkmm-2.8.2
	>=gnome-base/libglade-2.5.1
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/cairomm-0.6.0
	>=x11-libs/startup-notification-0.8
	>=media-libs/taglib-1.4
	aac? ( media-libs/faad2 )
	sid? ( media-libs/libsidplay )
	>=media-libs/gst-plugins-base-0.10.10
	>=media-libs/gst-plugins-good-0.10.3
	>=media-libs/musicbrainz-2.1.1
	>=media-libs/gstreamer-0.10.10
	virtual/fam
	>=sys-apps/dbus-0.62
	>=dev-libs/libxml2-2.6.1
	>=net-misc/neon-0.25.5
	ofa? ( >=media-libs/libofa-0.9.3 )
	raptor? ( >=media-libs/raptor-1.4.8 )
	hal? ( >=sys-apps/hal-0.5.5.1 )
	gaim? ( >=net-im/gaim-1.9.9 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.17
	nls? ( >=sys-devel/gettext-0.14.1
		>=dev-util/intltool-0.31.2 )
	mad? ( >=media-plugins/gst-plugins-mad-0.10.3 )
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10.10 )
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10.10 )
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10.1 )
	aac? ( >=media-plugins/gst-plugins-faad-0.10.1 )
	alsa? ( >=media-plugins/gst-plugins-alsa-0.10.10 )
	oss? ( >=media-plugins/gst-plugins-oss-0.10.3 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.3 )
	theora? ( >=media-plugins/gst-plugins-theora-0.10.10 )
	sid? ( >=media-plugins/gst-plugins-sidplay-0.10.3 )
	cdparanoia? ( >=media-plugins/gst-plugins-cdparanoia-0.10.10 )
	musepack? ( >=media-plugins/gst-plugins-musepack-0.10.3 )"

pkg_setup() {
	if use gaim && ! built_with_use net-im/gaim dbus; then
		die "You need to build net-im/gaim with USE dbus."
	fi
}

src_compile() {
	econf --disable-python \
		$(use_with aac mp4v2) \
		$(use_enable raptor) \
		$(use_enable hal) \
		$(use_enable gaim) \
		$(use_enable nls) \
		$(use_enable ofa) \
		$(use_enable sid) \
		$(use_enable debug) || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	elog "Before filing bugs to Gentoo or upstream note following:"
	elog
	elog "If you experience problems with DBUS, read documentation at"
	elog "http://bmpx.beep-media-player.org/site/FAQ#Running_with_D-BUS"
}
