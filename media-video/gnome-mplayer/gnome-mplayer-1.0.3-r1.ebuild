# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gnome-mplayer/gnome-mplayer-1.0.3-r1.ebuild,v 1.2 2011/04/23 09:00:24 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="A GTK+ interface to MPlayer"
HOMEPAGE="http://code.google.com/p/gnome-mplayer/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="alsa dbus gnome ipod libnotify musicbrainz pulseaudio"

RDEPEND=">=dev-libs/glib-2.26:2
	>=media-video/mplayer-1.0_rc4_p20091026-r1[ass]
	>=x11-libs/gtk+-2.22:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
	alsa? ( media-libs/alsa-lib )
	dbus? ( >=dev-libs/dbus-glib-0.92 )
	gnome? ( gnome-base/gvfs
		gnome-base/nautilus )
	ipod? ( >=media-libs/libgpod-0.7 )
	libnotify? ( x11-libs/libnotify )
	musicbrainz? ( net-misc/curl
		>=media-libs/musicbrainz-3 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.14 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

DOCS="ChangeLog README DOCS/keyboard_shortcuts.txt DOCS/tech/dbus.txt DOCS/tech/plugin-interaction.txt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.2-implicit_declaration.patch
}

src_configure() {
	# FIXME: The only reason why --without-gpm-new-method is passed is lack of testing.
	econf \
		$(use_enable gnome nautilus) \
		--enable-panscan \
		--disable-gseal \
		--without-gconf \
		--with-gio \
		$(use_with dbus) \
		$(use_with alsa) \
		$(use_with pulseaudio) \
		$(use_with libnotify) \
		$(use_with ipod libgpod) \
		$(use_with musicbrainz libmusicbrainz3) \
		--without-gpm-new-method \
		--without-gpm-old-method
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc/${PN}
}
