# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-weather/xfce4-weather-0.6.4.ebuild,v 1.2 2009/07/09 22:05:00 ssuominen Exp $

inherit autotools xfce4

xfce4_panel_plugin

DESCRIPTION="Weather monitor panel plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DOCS="AUTHORS ChangeLog NEWS README TODO"

DEPEND="dev-util/intltool
	dev-util/xfce4-dev-tools"

src_unpack() {
	unpack ${A}
	cd "${S}"
	intltoolize --force --copy --automake || die "intltoolize failed"
	AT_M4DIR="/usr/share/xfce4/dev-tools/m4macros" eautoreconf
}
