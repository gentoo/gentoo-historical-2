# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4/xfce4-4.2.0.ebuild,v 1.9 2005/02/09 00:06:53 kloeri Exp $

DESCRIPTION="Xfce 4 base ebuild"
LICENSE="GPL-2 BSD LGPL-2"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 sparc x86"

RDEPEND="~xfce-base/xfce-mcs-plugins-${PV}
	~xfce-base/xfce4-panel-${PV}
	~xfce-base/xfwm4-${PV}
	~xfce-base/xfce-utils-${PV}
	~xfce-base/xfdesktop-${PV}
	~xfce-base/xfce4-session-${PV}
	~xfce-base/xfprint-${PV}
	~xfce-extra/xfce4-iconbox-${PV}
	~xfce-extra/xfce4-systray-${PV}
	~xfce-extra/xfce4-toys-${PV}
	~xfce-extra/xfce4-trigger-launcher-${PV}
	~xfce-extra/xfwm4-themes-${PV}
	~xfce-extra/xfcalendar-${PV}
	~xfce-extra/xfce4-appfinder-${PV}
	~xfce-extra/xfce4-icon-theme-${PV}
	~xfce-base/xffm-${PV}
	~xfce-extra/xfce4-mixer-${PV}
	!xfce-base/xfce4-base"
XFCE_META=1

inherit xfce4

pkg_postinst() {
	einfo ""
	ewarn "As of Xfce 4.2 xfce-base/xfce4-base is deprecated, please remove it."
	einfo ""
	einfo "For extra functionality please emerge xfce-base/xfce4-extras."
	einfo "To start Xfce the default script is startxfce4."
	einfo ""
	ewarn "The composite extension in Xorg along with the compositor in"
	ewarn "Xfwm4 are still experimental and buggy, please refrain from"
	ewarn "filing bugs upstream for these features."
	einfo ""
	ewarn "Some or all of your plugins will need to be re-compiled after"
	ewarn "an upgrade from 4.0 to 4.2."
	einfo ""
}