# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4/xfce4-4.0.4.ebuild,v 1.7 2004/04/20 22:15:59 jhuebel Exp $

IUSE=""
DESCRIPTION="XFCE4, a lightweight Desktop Environment"
HOMEPAGE="http://www.xfce.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ia64 x86 ~ppc ~alpha sparc amd64 hppa ~mips"

DEPEND="=xfce-base/xfce4-base-${PV}
	=xfce-extra/xfce4-systray-${PV}
	=xfce-extra/xfce4-iconbox-${PV}
	>=xfce-extra/xfce4-battery-0.1.1
	=xfce-extra/xfce4-mixer-${PV}
	>=xfce-extra/xfce4-systemload-0.3.2
	<=xfce-extra/xfce4-themes-${PV}
	=xfce-extra/xfce4-toys-${PV}
	=xfce-extra/xfce4-trigger-launcher-${PV}
	<=xfce-extra/xffm-icons-${PV}
	<=xfce-extra/xfwm4-themes-${PV}
	>=xfce-extra/xfce4-showdesktop-0.1.1
	>=xfce-extra/xfce4-minicmd-0.1.1
	>=xfce-extra/xfce4-netload-0.1.3
	>=xfce-extra/xfcalendar-0.1.4"

src_install() {
	einfo "This is just a wrapper script to install all the components of Xfce4 and"
	einfo "all the extras."
}
