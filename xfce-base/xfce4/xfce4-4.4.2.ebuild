# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4/xfce4-4.4.2.ebuild,v 1.13 2008/06/22 22:56:41 drac Exp $

HOMEPAGE="http://www.xfce.org"
DESCRIPTION="Meta package for Xfce4 desktop, merge this package to install."
SRC_URI=""

LICENSE="as-is"
SLOT="0"
IUSE="alsa cups minimal oss xscreensaver"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

RDEPEND=">=x11-themes/gtk-engines-xfce-2.4
	>=xfce-base/thunar-0.8
	>=xfce-base/xfce-mcs-plugins-4.4
	>=xfce-base/xfce4-panel-4.4
	>=xfce-base/xfwm4-4.4
	>=xfce-base/xfce-utils-4.4
	>=xfce-base/xfdesktop-4.4
	>=xfce-base/xfce4-session-4.4
	x11-themes/xfce4-icon-theme
	alsa? ( >=xfce-extra/xfce4-mixer-4.4 )
	oss? ( >=xfce-extra/xfce4-mixer-4.4 )
	cups? ( >=net-print/xfprint-4.4 )
	!minimal? ( >=xfce-base/orage-4.4
		app-editors/mousepad
		x11-themes/xfwm4-themes
		x11-terms/terminal
		>=xfce-extra/xfce4-appfinder-4.4 )
	xscreensaver? ( || ( x11-misc/xscreensaver
		gnome-extra/gnome-screensaver ) )"

src_install() {
	dodir /etc/X11/Sessions
	echo startxfce4 > "${D}"/etc/X11/Sessions/Xfce4
	fperms 755 /etc/X11/Sessions/Xfce4
}

pkg_postinst() {
	elog
	elog "Run Xfce4 from your favourite Display Manager by using"
	elog "XSESSION=\"Xfce4\" in /etc/rc.conf"
	elog
}
