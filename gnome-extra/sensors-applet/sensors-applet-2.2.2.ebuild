# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/sensors-applet/sensors-applet-2.2.2.ebuild,v 1.1 2009/03/08 11:32:14 eva Exp $

EAPI="2"

inherit autotools gnome2 eutils

DESCRIPTION="GNOME panel applet to display readings from hardware sensors"
HOMEPAGE="http://sensors-applet.sourceforge.net/"
SRC_URI="mirror://sourceforge/sensors-applet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="hddtemp libnotify lm_sensors nvidia"

RDEPEND="
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.8.0
	>=gnome-base/gnome-panel-2
	>=gnome-base/libgnome-2.8
	>=gnome-base/libgnomeui-2.8
	>=x11-libs/cairo-1.0.4
	hddtemp? ( >=app-admin/hddtemp-0.3_beta13 )
	libnotify? ( >=x11-libs/libnotify-0.4.0 )
	lm_sensors? ( sys-apps/lm_sensors )
	nvidia? ( || (
		>=x11-drivers/nvidia-drivers-100.14.09
		media-video/nvidia-settings
	) )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with nvidia)
		$(use_with lm_sensors libsensors)
		$(use_enable libnotify)
		--disable-static"
}

src_prepare() {
	# Fix nvidia library detection, bug #221817
	if use nvidia; then
		epatch "${FILESDIR}/${P}-nvidia-check.patch"
		intltoolize --force --copy --automake || die "intltoolize failed"
		eautoreconf
	fi
}
