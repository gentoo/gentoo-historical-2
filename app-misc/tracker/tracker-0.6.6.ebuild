# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tracker/tracker-0.6.6.ebuild,v 1.2 2008/10/11 23:01:21 eva Exp $

inherit autotools eutils flag-o-matic linux-info

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="http://www.tracker-project.org/"
SRC_URI="http://www.gnome.org/~jamiemcc/tracker/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="applet debug deskbar gnome gsf gstreamer gtk hal jpeg pdf xine kernel_linux"

RDEPEND=">=dev-libs/glib-2.14.0
		 >=x11-libs/pango-1.0.0
		 =dev-libs/gmime-2.2*
		 >=dev-libs/dbus-glib-0.71
		 >=media-libs/libpng-1.2
		 >=dev-db/qdbm-1.8
		 >=dev-libs/libxml2-2.6
		 >=dev-db/sqlite-3.4
		 >=media-gfx/imagemagick-5.2.1
		 applet? ( >=x11-libs/libnotify-0.4.3 )
		 deskbar? ( >=gnome-extra/deskbar-applet-2.19 )
		 gnome? (
					>=x11-libs/gtk+-2.8
					>=gnome-base/libgnome-2.14
					>=gnome-base/libgnomeui-2.14
					>=gnome-base/gnome-vfs-2.10
					>=gnome-base/gnome-desktop-2.14
					>=gnome-base/libglade-2.5
				)
		 gsf? ( >=gnome-extra/libgsf-1.13 )
		 gstreamer? ( >=media-libs/gstreamer-0.10 )
		 !gstreamer? ( !xine? ( || ( media-video/totem media-video/mplayer ) ) )
		 gtk? ( >=x11-libs/gtk+-2.8.20 )
		 hal? ( >=sys-apps/hal-0.5 )
		 jpeg? ( >=media-gfx/exif-0.6 )
		 !kernel_linux? ( >=app-admin/gamin-0.1.7 )
		 pdf?	(
					>=x11-libs/cairo-1.0
					>=app-text/poppler-bindings-0.5.0
				)
		 xine? ( >=media-libs/xine-lib-1.0 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=sys-devel/gettext-0.14
		>=dev-util/pkgconfig-0.20"

function notify_inotify() {
	ewarn
	ewarn "You should enable the INOTIFY support in your kernel."
	ewarn "Check the 'Inotify file change notification support' under the"
	ewarn "'File systems' option.  It is marked as CONFIG_INOTIFY in the config"
	ewarn "Also enable 'Inotify support for userland' in under the previous"
	ewarn "option.  It is marked as CONFIG_INOTIFY_USER in the config."
	ewarn
	die 'missing CONFIG_INOTIFY'
}

function inotify_enabled() {
	linux_chkconfig_present INOTIFY && linux_chkconfig_present INOTIFY_USER
}

pkg_setup() {
	linux-info_pkg_setup

	if built_with_use --missing false 'dev-db/sqlite' 'nothreadsafe' ||
		! built_with_use --missing true 'dev-db/sqlite' 'threadsafe' ; then
		eerror "You must build sqlite with threading support"
		die "dev-db/sqlite built without thread safety"
	fi

	if ! built_with_use 'media-gfx/imagemagick' 'png' ; then
		ewarn "You must build imagemagick with png"
		die "imagemagick needs png support"
	fi

	if use pdf && ! built_with_use 'app-text/poppler-bindings' 'gtk' ; then
		ewarn "You must build poppler-bindings with gtk to get support for PDFs"
		die "poppler-bindings needs gtk support"
	fi

	if use jpeg && ! built_with_use 'media-gfx/imagemagick' 'jpeg' ; then
		ewarn "You must build imagemagick with jpeg to get support for JPEG"
		die "imagemagick needs jpeg support"
	fi

	if use kernel_linux ; then
		inotify_enabled || notify_inotify
	fi
}

src_compile() {
	local myconf=

	if use gstreamer ; then
		myconf="${myconf} --enable-video-extractor=gstreamer"
	elif use xine ; then
		myconf="${myconf} --enable-video-extractor=xine"
	else
		myconf="${myconf} --enable-video-extractor=external"
	fi

	if use kernel_linux ; then
		myconf="${myconf} --enable-file-monitoring=inotify"
	else
		myconf="${myconf} --enable-file-monitoring=fam"
	fi

	econf ${myconf} \
		  --disable-xmp --disable-unac \
		  --enable-preferences --enable-external-qdbm \
		  $(use_enable applet trackerapplet) \
		  $(use_enable deskbar deskbar-applet auto) \
		  $(use_enable debug debug-code) \
		  $(use_enable gnome gui) \
		  $(use_enable gsf) \
		  $(use_enable gtk libtrackergtk) \
		  $(use_enable hal) \
		  $(use_enable jpeg exif) \
		  $(use_enable pdf) \
		|| die "configure failed"

	emake || die "build failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
