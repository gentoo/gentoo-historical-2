# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-0.7.1.ebuild,v 1.4 2008/06/12 12:36:55 opfer Exp $

inherit gnome2

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="beagle dbus dvd gdl libburn libnotify totem"

RESTRICT="test"

RDEPEND=">=x11-libs/gtk+-2.11.6
	>=gnome-base/libgnome-2.10
	>=gnome-base/libgnomeui-2.10
	>=gnome-base/gnome-vfs-2.14.2
	>=media-libs/gstreamer-0.10.6
	>=media-libs/gst-plugins-base-0.10.6
	>=media-plugins/gst-plugins-ffmpeg-0.10
	>=gnome-extra/nautilus-cd-burner-2.16.0
	>=dev-libs/libxml2-2.6
	>=sys-apps/hal-0.5.5
	app-cdr/cdrdao
	virtual/cdrtools
	gnome-base/gnome-mount
	dbus? ( >=sys-apps/dbus-0.7.2 )
	dvd? ( media-libs/libdvdcss
		app-cdr/dvd+rw-tools )
	gdl? ( >=dev-libs/gdl-0.6 )
	totem? ( >=media-video/totem-1.4.2 )
	beagle? ( || ( dev-libs/libbeagle ~app-misc/beagle-0.2.18 ) )
	libnotify? ( >=x11-libs/libnotify-0.3.0 )
	libburn? ( >=dev-libs/libburn-0.4.0
		>=dev-libs/libisofs-0.2.8 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

pkg_setup() {
	G2CONF="${G2CONF} --disable-caches
		$(use_enable totem playlist)
		$(use_enable beagle search)
		$(use_enable dbus)
		$(use_enable libburn libburnia)
		$(use_enable libnotify)"

	DOCS="AUTHORS ChangeLog NEWS README TODO.tasks"
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "For the best experience you should have a Linux kernel >= 2.6.13"
	elog "to enable system features such as Extended Attributes and inotify."
	echo
	elog "To use the libburn backend you need to add USE=libburn and activate"
	elog "it in gconf editor. Note that the default backend is cdrtools/cdrkit."
	echo
}
