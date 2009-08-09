# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4/xfce4-4.6.1.ebuild,v 1.11 2009/08/09 08:59:56 ssuominen Exp $

HOMEPAGE="http://www.xfce.org"
DESCRIPTION="Meta package for Xfce4 desktop, merge this package to install."
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="alsa cups minimal oss"

RDEPEND="x11-themes/gtk-engines-xfce
	>=xfce-base/xfce4-panel-${PV}
	>=xfce-base/xfwm4-${PV}
	>=xfce-base/xfce-utils-${PV}
	>=xfce-base/xfdesktop-${PV}
	>=xfce-base/xfce4-session-${PV}
	alsa? ( >=xfce-extra/xfce4-mixer-${PV} )
	oss? ( >=xfce-extra/xfce4-mixer-${PV} )
	cups? ( >=net-print/xfprint-${PV} )
	!minimal? ( >=app-office/orage-${PV}
		app-editors/mousepad
		x11-terms/terminal
		x11-themes/xfce4-icon-theme
		>=xfce-base/thunar-0.9.92
		>=x11-themes/xfwm4-themes-4.6
		>=xfce-extra/xfce4-appfinder-${PV} )
	minimal? ( x11-themes/hicolor-icon-theme )"
DEPEND=""
