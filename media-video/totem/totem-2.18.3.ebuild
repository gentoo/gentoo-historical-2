# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-2.18.3.ebuild,v 1.10 2008/10/05 21:28:52 eva Exp $

inherit autotools eutils gnome2 multilib

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://gnome.org/projects/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="arm sh"

# No 0.10.0 release for gst-plugins-pitdfdll yet
# IUSE="win32codecs"

IUSE="a52 debug dvd ffmpeg flac gnome hal lirc mad mpeg nsplugin nvtv ogg seamonkey theora vorbis xulrunner xv"

RDEPEND=">=dev-libs/glib-2.12
	 >=x11-libs/gtk+-2.10
	 >=gnome-base/gconf-2.0
	 >=gnome-base/libglade-2.0
	 >=gnome-base/gnome-vfs-2.10
	 >=x11-themes/gnome-icon-theme-2.15.90
	 >=x11-libs/startup-notification-0.8
	   app-text/iso-codes
	   dev-libs/libxml2
	 >=dev-libs/dbus-glib-0.71
	 >=media-libs/gstreamer-0.10.6
	 >=media-libs/gst-plugins-good-0.10
	 >=media-libs/gst-plugins-base-0.10.7
	 >=media-plugins/gst-plugins-pango-0.10
	 >=media-plugins/gst-plugins-gconf-0.10
	 >=media-plugins/gst-plugins-gnomevfs-0.10

	 x11-libs/libX11
	 x11-libs/libXtst
	 >=x11-libs/libXrandr-1.1.1
	 >=x11-libs/libXxf86vm-1.0.1

	 gnome? (
				>=gnome-base/libgnome-2.14
				>=gnome-base/libgnomeui-2.4
				>=gnome-base/gnome-desktop-2.2
				>=gnome-base/nautilus-2.10
			)
	 hal? ( =sys-apps/hal-0.5* )
	 lirc? ( app-misc/lirc )
	 nsplugin?	(
				xulrunner? ( =net-libs/xulrunner-1.8* )
				!xulrunner?	(
								seamonkey? ( =www-client/seamonkey-1* )
								!seamonkey? ( =www-client/mozilla-firefox-2* )
							)
				>=x11-misc/shared-mime-info-0.17
				>=x11-libs/startup-notification-0.8
				)
	 nvtv? ( >=media-tv/nvtv-0.4.5 )

	 a52? ( >=media-plugins/gst-plugins-a52dec-0.10 )
	 dvd? (
				>=media-libs/gst-plugins-ugly-0.10
				>=media-plugins/gst-plugins-a52dec-0.10
				>=media-plugins/gst-plugins-dvdread-0.10
				>=media-plugins/gst-plugins-mpeg2dec-0.10
			)
	 !sparc? ( ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 ) )
	 flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	 mad? ( >=media-plugins/gst-plugins-mad-0.10 )
	 mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.10 )
	 ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
	 theora? (
				>=media-plugins/gst-plugins-ogg-0.10
				>=media-plugins/gst-plugins-theora-0.10
			 )
	 vorbis? (
				>=media-plugins/gst-plugins-ogg-0.10
				>=media-plugins/gst-plugins-vorbis-0.10
			 )
	 xv? ( >=media-plugins/gst-plugins-xvideo-0.10 )
	>=media-plugins/gst-plugins-x-0.10"

# this belongs above xv? above.
# win32codecs? ( >=media-plugins/gst-plugins-pitfdll-0.10 )

DEPEND="${RDEPEND}
	  x11-proto/xproto
	  x11-proto/inputproto
	  app-text/scrollkeeper
	  gnome-base/gnome-common
	  app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	# use global mozilla plugin dir
	G2CONF="${G2CONF} MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins"

	G2CONF="${G2CONF} --disable-vanity --enable-gstreamer --with-dbus"

	if use gnome ; then
	    G2CONF="${G2CONF} --disable-gtk --enable-nautilus"
	else
	    G2CONF="${G2CONF} --enable-gtk"
	fi

	if use nsplugin ; then
	    G2CONF="${G2CONF} --enable-browser-plugins"
		if use xulrunner ; then
			G2CONF="${G2CONF} --with-gecko=xulrunner"
		elif use seamonkey ; then
			G2CONF="${G2CONF} --with-gecko=seamonkey"
		else
			G2CONF="${G2CONF} --with-gecko=firefox"
		fi
	else
	    G2CONF="${G2CONF} --disable-browser-plugins"
	fi

	G2CONF="${G2CONF} \
		$(use_enable debug) \
		$(use_with hal) \
		$(use_enable lirc) \
		$(use_enable nvtv)"
}

src_unpack() {
	gnome2_src_unpack

	# Remove the intltoolize call when tarballs are made with >=intltool-0.35.5
	intltoolize --force || die

	if use nsplugin ; then
		epatch "${FILESDIR}"/${PN}-2.18.1-browser-plugins.patch
		eautoreconf
	fi

	# Remove this when POTFILES.in will be fixed
	echo "data/totem-handlers.schemas.in" >> "${S}"/po/POTFILES.skip
	echo "data/totem-video-thumbnail.schemas.in" >> "${S}"/po/POTFILES.skip
	echo "data/totem.desktop.in" >> "${S}"/po/POTFILES.skip
	echo "data/totem.desktop.in.in" >> "${S}"/po/POTFILES.skip
	echo "data/vanity.desktop.in" >> "${S}"/po/POTFILES.skip
}

src_install() {
	gnome2_src_install plugindir=/usr/$(get_libdir)/nsbrowser/plugins
}

src_compile() {
	#fixme: why does it need write access here, probably need to set up a fake
	#home in /var/tmp like other pkgs do

	addpredict "/root/.gconfd"
	addpredict "/root/.gconf"
	addpredict "/root/.gnome2"

	gnome2_src_compile
}
