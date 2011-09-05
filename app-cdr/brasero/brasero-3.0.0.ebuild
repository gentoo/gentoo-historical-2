# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-3.0.0.ebuild,v 1.2 2011/09/05 20:32:57 maekke Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2 multilib

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://projects.gnome.org/brasero/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+css doc +introspection +libburn nautilus packagekit playlist test"

COMMON_DEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=gnome-base/gconf-2.32.0:2
	>=media-libs/gstreamer-0.10.15:0.10
	>=media-libs/gst-plugins-base-0.10:0.10
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/libnotify-0.6.1

	media-libs/libcanberra[gtk3]
	x11-libs/libICE
	x11-libs/libSM

	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.91.90 )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1 )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:0.10
	x11-themes/hicolor-icon-theme
	css? ( media-libs/libdvdcss:1.2 )
	!libburn? (
		app-cdr/cdrdao
		app-cdr/dvd+rw-tools
		virtual/cdrtools )
	packagekit? ( app-admin/packagekit-base )"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	gnome-base/gnome-common:3
	>=dev-util/gtk-doc-am-1.12
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( app-text/docbook-xml-dtd:4.3 )"
# eautoreconf deps
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am
PDEPEND="gnome-base/gvfs"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		--disable-search
		$(use_enable !libburn cdrtools)
		$(use_enable !libburn cdrkit)
		$(use_enable !libburn cdrdao)
		$(use_enable !libburn growisofs)
		$(use_enable introspection)
		$(use_enable libburn libburnia)
		$(use_enable nautilus)
		$(use_enable playlist)"

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_prepare() {
	# Fix linking against installed libraries, bug #340767, gnome #641233
	epatch "${FILESDIR}/${PN}-2.91.6-build-plugins-against-local-library.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
