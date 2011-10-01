# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-2.90.1_pre20111001.ebuild,v 1.1 2011/10/01 16:42:01 nirbheek Exp $

EAPI="3"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.5"
PYTHON_USE_WITH="xml"
PYTHON_USE_WITH_OPT="python"

inherit autotools gnome2 python multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
# Git snapshot
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE="cdr clutter daap dbus doc gnome-keyring html ipod +lastfm libnotify lirc
musicbrainz mtp nsplugin python test udev upnp webkit"
# vala
KEYWORDS="~amd64 ~x86"

# FIXME: double check what to do with fm-radio plugin
# FIXME: Zeitgeist python plugin
# NOTE: Rhythmbox uses both gdbus and dbus-python right now
# NOTE: gst-python is still needed because gstreamer introspection is incomplete
COMMON_DEPEND=">=dev-libs/glib-2.26.0:2
	dev-libs/libxml2:2
	>=x11-libs/gtk+-2.91.4:3[introspection]
	>=x11-libs/gdk-pixbuf-2.18.0:2
	>=dev-libs/gobject-introspection-0.10.0
	>=dev-libs/libpeas-0.7.3[gtk,python?]
	>=dev-libs/totem-pl-parser-2.32.1
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4
	>=media-libs/gst-plugins-base-0.10.32:0.10
	>=media-libs/gstreamer-0.10.32:0.10[introspection]

	clutter? (
		>=media-libs/clutter-1.2:1.0
		>=media-libs/clutter-gst-1.0:1.0
		>=media-libs/clutter-gtk-1.0:1.0
		>=x11-libs/mx-1.0.1:1.0 )
	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		>=net-libs/libdmapsharing-2.9.11:3.0
		>=net-dns/avahi-0.6 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	html? ( >=net-libs/webkit-gtk-1.3.9:3 )
	lastfm? ( dev-libs/json-glib )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	musicbrainz? (
		media-libs/musicbrainz:3
		gnome-base/gconf:2 )
	python? ( >=dev-python/pygobject-2.28:2[introspection] )
	udev? (
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 )
		|| ( >=sys-fs/udev-171[gudev] >=sys-fs/udev-145[extras] ) )
"
RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-soup-0.10
	>=media-plugins/gst-plugins-libmms-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-taglib-0.10.6
	upnp? (
		>=media-libs/grilo-0.1.17
		>=media-plugins/grilo-plugins-0.1.17[upnp] )
	python? (
		>=dev-python/gst-python-0.10.8

		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( dev-python/dbus-python )
		gnome-keyring? ( dev-python/gnome-keyring-python )
		webkit? (
			dev-python/mako
			>=net-libs/webkit-gtk-1.3.9:3[introspection] ) )
"
# gtk-doc-am needed for eautoreconf
#	dev-util/gtk-doc-am
# gtk-doc is needed for gtkdocize
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	dev-util/gtk-doc
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? ( dev-libs/check )"
#	vala? ( >=dev-lang/vala-0.9.4:0.12 )
DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
	  MAINTAINERS MAINTAINERS.old NEWS README THANKS"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
		G2CONF="${G2CONF} PYTHON=$(PYTHON -2)"
	fi

	if ! use udev; then
		if use ipod; then
			ewarn "ipod support requires udev support.  Please"
			ewarn "re-emerge with USE=udev to enable ipod support"
			G2CONF="${G2CONF} --without-ipod"
		fi

		if use mtp; then
			ewarn "MTP support requires udev support.  Please"
			ewarn "re-emerge with USE=udev to enable MTP support"
			G2CONF="${G2CONF} --without-mtp"
		fi
	else
		G2CONF="${G2CONF} $(use_with ipod) $(use_with mtp)"
	fi

	if ! use cdr ; then
		ewarn "You have cdr USE flag disabled."
		ewarn "You will not be able to burn CDs."
	fi

	if ! use python; then
		if use dbus; then
			ewarn "You need python support to use the im-status plugin"
		fi

		if use webkit; then
			ewarn "You need python support in addition to webkit to be able to use"
			ewarn "the context panel plugin."
		fi
	fi

	if use gnome-keyring && ! use python; then
		ewarn "The magnatune plugin requires USE='python gnome-keyring'"
	fi

	# --enable-vala just installs the sample vala plugin, and the configure
	# checks are broken, so don't enable it
	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		VALAC=$(type -P valac-0.12)
		--enable-mmkeys
		--disable-more-warnings
		--disable-scrollkeeper
		--disable-schemas-compile
		--disable-static
		--disable-vala
		--without-hal
		$(use_enable clutter visualizer)
		$(use_enable daap)
		$(use_enable lastfm)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable musicbrainz)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable upnp grilo)
		$(use_with cdr brasero)
		$(use_with daap mdns avahi)
		$(use_with gnome-keyring)
		$(use_with html webkit)
		$(use_with ipod)
		$(use_with mtp)
		$(use_with udev gudev)"

	export GST_INSPECT=/bin/true
}

src_prepare() {
	gnome2_src_prepare

	# Git snapshot, remove for release
	# make dist wasn't working, so no proper snapshot tarball
	gtkdocize || die
	gnome-doc-common || die
	gnome-doc-prepare --automake || die
	intltoolize --force || die
	eautoreconf

	# disable pyc compiling
	ln -sfn $(type -P true) py-compile
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "test failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/rhythmbox/plugins
	fi

	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/rhythmbox/plugins
}
