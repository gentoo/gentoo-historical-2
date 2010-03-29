# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-sensors-plugin/xfce4-sensors-plugin-1.0.0.ebuild,v 1.1 2010/03/29 14:53:50 darkside Exp $

EAUTORECONF=yes
EAPI=2
inherit xfconf

DESCRIPTION="acpi, lm_sensors and hddtemp panel plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/1.0/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="acpi debug hddtemp libnotify lm_sensors"

RDEPEND=">=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.4
	>=xfce-base/xfce4-panel-4.4
	libnotify? ( >=x11-libs/libnotify-0.4 )
	lm_sensors? ( sys-apps/lm_sensors )
	hddtemp? ( app-admin/hddtemp )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable hddtemp)
		$(use_enable lm_sensors libsensors)
		$(use_enable acpi procacpi)
		$(use_enable acpi sysfsacpi)
		$(use_enable debug)
		$(use_enable libnotify notification)"

	if ! use hddtemp && ! use lm_sensors && ! use acpi; then
		XFCONF="${XFCONF} --enable-procacpi --enable-sysfsacpi"
	fi

	DOCS="AUTHORS ChangeLog NEWS NOTES README TODO"
}

src_prepare() {
	sed -i -e '/-no-undefined/d' src/Makefile.am || die
	sed -i -e 's/-Werror//' configure.in || die
	xfconf_src_prepare
}
