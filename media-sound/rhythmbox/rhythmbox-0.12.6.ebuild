# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.12.6.ebuild,v 1.9 2010/07/12 10:14:02 pacho Exp $

EAPI="2"

inherit gnome2 python multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="cdr daap doc gnome-keyring hal ipod libnotify lirc musicbrainz mtp nsplugin python test udev"

# FIXME: double check what to do with fm-radio plugin
# TODO: watchout for udev use flag changes

SLOT="0"

COMMON_DEPEND=">=dev-libs/glib-2.16.0
	dev-libs/libxml2
	>=x11-libs/gtk+-2.16
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/totem-pl-parser-2.26.0
	>=gnome-base/gconf-2
	>=gnome-extra/gnome-media-2.14.0
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4

	>=media-libs/gst-plugins-base-0.10.20
	|| (
		>=media-libs/gst-plugins-base-0.10.24
		>=media-libs/gst-plugins-bad-0.10.6 )

	cdr? ( >=app-cdr/brasero-0.9.1 )
	daap? ( >=net-dns/avahi-0.6 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	udev? (
		ipod? ( >=media-libs/libgpod-0.6 )
		mtp? ( >=media-libs/libmtp-0.3.0 )
		>=sys-fs/udev-145[extras] )
	hal? (
		ipod? ( >=media-libs/libgpod-0.6 )
		mtp? ( >=media-libs/libmtp-0.3.0 )
		>=sys-apps/hal-0.5 )
	libnotify? ( >=x11-libs/libnotify-0.4.1 )
	lirc? ( app-misc/lirc )
	musicbrainz? ( media-libs/musicbrainz:3 )
	python? (
		>=dev-lang/python-2.4.2
		|| (
			>=dev-lang/python-2.5
			dev-python/celementtree )
		>=dev-python/pygtk-2.8
		>=dev-python/gnome-vfs-python-2.22.0
		>=dev-python/gconf-python-2.22.0
		>=dev-python/libgnome-python-2.22.0
		>=dev-python/gst-python-0.10.8 )"

RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-soup-0.10
	>=media-plugins/gst-plugins-libmms-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-taglib-0.10.6
	nsplugin? ( net-libs/xulrunner )"

# gtk-doc-am needed for eautoreconf
#	dev-util/gtk-doc-am
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? ( dev-libs/check )"

DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
	  MAINTAINERS MAINTAINERS.old NEWS README THANKS"

pkg_setup() {
	if ! use hal && ! use udev; then
		if use ipod; then
			ewarn "ipod support requires hal or udev support.  Please"
			ewarn "re-emerge with USE=udev to enable ipod support"
		fi

		if use mtp; then
			ewarn "MTP support requires hal or udev support.  Please"
			ewarn "re-emerge with USE=udev to enable MTP support"
		fi
	fi

	if use hal && use udev; then
		einfo "udev support replaces hal support completely. You can disable"
		einfo "hal on this package via /etc/portage/package.use."
	fi

	if ! use cdr ; then
		ewarn "You have cdr USE flag disabled."
		ewarn "You will not be able to burn CDs."
	else
		G2CONF="${G2CONF} $(use_with cdr libbrasero-media) --without-libnautilus-burn"
	fi

	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		$(use_with gnome-keyring)
		$(use_with udev gudev)
		$(use_with hal)
		$(use_with ipod)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable musicbrainz)
		$(use_with mtp)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable daap)
		$(use_with daap mdns avahi)
		--enable-mmkeys
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-static
		--disable-vala"

	export GST_INSPECT=/bin/true
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "test failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/rhythmbox/plugins

	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/rhythmbox/plugins
}
