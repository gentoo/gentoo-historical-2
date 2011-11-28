# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/sensors-applet/sensors-applet-3.0.0.ebuild,v 1.2 2011/11/28 23:05:13 ssuominen Exp $

EAPI=4
GCONF_DEBUG=no
inherit gnome2

DESCRIPTION="GNOME panel applet to display readings from hardware sensors"
HOMEPAGE="http://sensors-applet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="hddtemp libnotify lm_sensors +udev video_cards_fglrx video_cards_nvidia"

RDEPEND=">=dev-libs/glib-2.22
	x11-libs/gtk+:3
	>=gnome-base/gnome-panel-3
	x11-libs/cairo
	hddtemp? (
		udev? (	>=dev-libs/dbus-glib-0.98 >=dev-libs/libatasmart-0.18 )
		!udev? ( >=app-admin/hddtemp-0.3_beta13 ) )
	libnotify? ( x11-libs/libnotify )
	lm_sensors? ( sys-apps/lm_sensors )
	video_cards_fglrx? ( x11-drivers/ati-drivers )
	video_cards_nvidia? ( || ( >=x11-drivers/nvidia-drivers-100.14.09 media-video/nvidia-settings ) )"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	app-text/rarian
	dev-util/intltool
	dev-util/pkgconfig"

PDEPEND="hddtemp? ( udev? ( sys-fs/udisks ) )"

pkg_setup() {
	G2CONF="--disable-static
		$(use_enable udev udisks)
		$(use_enable libnotify)
		--disable-scrollkeeper
		$(use_with lm_sensors libsensors)
		$(use_with video_cards_fglrx aticonfig)
		$(use_with video_cards_nvidia nvidia)"

	if use hddtemp; then
		G2CONF+=" $(use_enable udev udisks)"
	else
		G2CONF+=" --disable-udisks"
	fi

	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	sed -i -e '/^CFLAGS.*_DISABLE_DEPRECATED/d' configure{,.ac} || die
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	rm -f "${ED}"usr/lib*/{,sensors-applet/plugins/}*.la
}
