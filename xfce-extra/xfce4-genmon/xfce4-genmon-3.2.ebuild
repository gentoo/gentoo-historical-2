# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-genmon/xfce4-genmon-3.2.ebuild,v 1.2 2008/04/10 14:43:45 drac Exp $

inherit xfce44

xfce44

DESCRIPTION="Cyclically spawns the indicated executable, captures its output and displays the result into the panel."
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=xfce-base/xfce4-panel-4.3.22"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog README"

xfce44_goodies_panel_plugin
