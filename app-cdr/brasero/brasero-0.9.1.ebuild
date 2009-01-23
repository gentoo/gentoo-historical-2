# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-0.9.1.ebuild,v 1.1 2009/01/23 17:00:41 loki_val Exp $

EAPI=1

GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="beagle +libburn totem cdrkit cdrtools +nautilus"

RDEPEND=">=dev-libs/glib-2.15.6
	>=x11-libs/gtk+-2.14.0
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10.15
	>=media-plugins/gst-plugins-ffmpeg-0.10
	>=dev-libs/libxml2-2.6
	sys-apps/hal
	gnome-base/gvfs
	app-cdr/cdrdao
	>=dev-libs/dbus-glib-0.7.2
	media-libs/libdvdcss
	app-cdr/dvd+rw-tools
	cdrtools? ( app-cdr/cdrtools )
	cdrkit? ( app-cdr/cdrkit )
	totem? ( >=dev-libs/totem-pl-parser-2.20 )
	beagle? ( >=dev-libs/libbeagle-0.3.0 )
	libburn? ( >=dev-libs/libburn-0.4.0
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.22.2 )"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	gnome-base/gconf"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		$(use cdrtools|| printf %s --disable-cdrtools)
		$(use_enable cdrkit)
		$(use_enable nautilus)
		$(use_enable totem playlist)
		$(use_enable beagle search)
		$(use_enable libburn libburnia)"

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_test() {
	BLING=$LINGUAS
	unset LINGUAS
	make check
	export LINGUAS=$BLING
	unset BLING
}
