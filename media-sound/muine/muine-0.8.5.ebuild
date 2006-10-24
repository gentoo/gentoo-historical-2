# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/muine/muine-0.8.5.ebuild,v 1.3 2006/10/24 01:16:12 latexer Exp $

inherit gnome2 mono eutils multilib autotools

DESCRIPTION="A music player for GNOME"
HOMEPAGE="http://muine-player.org/"
SRC_URI="${HOMEPAGE}/releases/${P}.tar.gz"

LICENSE="GPL-2"
IUSE="xine mad vorbis flac aac"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-lang/mono-1.1
	>=dev-dotnet/gtk-sharp-2.4.0
	>=dev-dotnet/gnome-sharp-2.4.0
	>=dev-dotnet/gnomevfs-sharp-2.4.0
	>=dev-dotnet/glade-sharp-2.4.0
	>=dev-dotnet/gconf-sharp-2.4.0
	xine? ( >=media-libs/xine-lib-1_rc4 )
	!xine? (
		=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-base-0.10*
		=media-libs/gst-plugins-good-0.10*
		=media-plugins/gst-plugins-gnomevfs-0.10*
		=media-plugins/gst-plugins-gconf-0.10*
		mad? ( =media-plugins/gst-plugins-mad-0.10* )
		vorbis? ( =media-plugins/gst-plugins-ogg-0.10*
			=media-plugins/gst-plugins-vorbis-0.10* )
		flac? ( =media-plugins/gst-plugins-flac-0.10* )
		aac? (
			=media-plugins/gst-plugins-faad-0.10*
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
	~media-libs/flac-1.1.2"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-util/monodoc-1.1.8
	dev-util/pkgconfig
	app-text/scrollkeeper"

use xine && \
	G2CONF="${G2CONF} --enable-gstreamer=no" || \
	G2CONF="${G2CONF} --enable-gstreamer=yes"


G2CONF="${G2CONF} $(use_enable aac faad2)"

USE_DESTDIR=1
DOCS="AUTHORS COPYING ChangeLog INSTALL \
	  MAINTAINERS NEWS README TODO"

AT_M4DIR="${S}/m4"

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

	intltoolize --force --copy || die "intltoolize failed"
	eautoreconf
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
