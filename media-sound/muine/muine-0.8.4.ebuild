# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muine/muine-0.8.4.ebuild,v 1.1 2006/01/30 06:44:43 latexer Exp $

inherit gnome2 mono eutils multilib

DESCRIPTION="A music player for GNOME"
HOMEPAGE="http://muine-player.org/"
SRC_URI="${HOMEPAGE}/releases/${P}.tar.gz"

LICENSE="GPL-2"
IUSE="xine mad vorbis flac aac"
SLOT="0"
KEYWORDS="~ppc ~x86"

RDEPEND=">=dev-lang/mono-1.1
	>=dev-dotnet/gtk-sharp-2.4.0
	>=dev-dotnet/gnome-sharp-2.4.0
	>=dev-dotnet/gnomevfs-sharp-2.4.0
	>=dev-dotnet/glade-sharp-2.4.0
	>=dev-dotnet/gconf-sharp-2.4.0
	xine? ( >=media-libs/xine-lib-1_rc4 )
	!xine? (
		=media-libs/gstreamer-0.8*
		=media-libs/gst-plugins-0.8*
		=media-plugins/gst-plugins-gnomevfs-0.8*
		mad? ( =media-plugins/gst-plugins-mad-0.8* )
		vorbis? ( =media-plugins/gst-plugins-ogg-0.8*
			=media-plugins/gst-plugins-vorbis-0.8* )
		flac? ( =media-plugins/gst-plugins-flac-0.8* )
		aac? (
			=media-plugins/gst-plugins-faad-0.8*
			>=media-libs/faad2-2.0-r4
		)
	)
	>=media-libs/libid3tag-0.15.0b
	>=media-libs/libvorbis-1.0
	sys-libs/gdbm
	>=gnome-base/gconf-2.0.0
	>=gnome-base/gnome-vfs-2.0.0
	>=x11-libs/gtk+-2.6.0
	>=dev-util/intltool-0.29
	>=sys-apps/dbus-0.23.2-r1
	media-libs/flac"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper"

use xine && \
	G2CONF="${G2CONF} --enable-gstreamer=no" || \
	G2CONF="${G2CONF} --enable-gstreamer=yes"


G2CONF="${G2CONF} $(use_enable aac faad2)"

USE_DESTDIR=1
DOCS="AUTHORS COPYING ChangeLog INSTALL \
	  MAINTAINERS NEWS README TODO"

pkg_setup() {
	if ! built_with_use sys-apps/dbus mono ; then
		echo
		eerror "In order to compile muine, you need to have sys-apps/dbus emerged"
		eerror "with 'mono' in your USE flags. Please add that flag, re-emerge"
		eerror "dbus, and then emerge muine."
		die "sys-apps/dbus is missing the .NET binding."
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix the install location of the dbus service file
	sed -i "s:libdir)/dbus-1.0:datadir)/dbus-1:" \
		${S}/data/Makefile.am || die "sed failed"

	libtoolize --force --copy || die "libtoolize failed"
	aclocal -I "${S}/m4" || die "aclocal failed"
	autoconf || die "autoconf failed"
	automake || die "automake failed"
}

src_compile() {
	gnome2_src_configure "$@"
	emake -j1 || die "compile failure"
}

src_install() {
	gnome2_src_install "$@"

	insinto /usr/$(get_libdir)/muine/plugins/
	doins ${S}/plugins/TrayIcon.dll
}

pkg_postinst() {
	einfo
	einfo "Upstream no longer packages the tray icon plugin by default."
	einfo "The Gentoo ebuilds will continue to install the plugin, if you don't"
	einfo "want to use the plugin, remove TrayIcon.dll from"
	einfo "/usr/$(get_libdir)/muine/plugins/"
}
