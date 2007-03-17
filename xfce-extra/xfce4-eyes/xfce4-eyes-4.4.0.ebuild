# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-eyes/xfce4-eyes-4.4.0.ebuild,v 1.7 2007/03/17 17:27:38 nixnut Exp $

inherit xfce44

xfce44

RESTRICT="test"

DESCRIPTION="Eyes is a panel plugin that adds eyes which watch your every step."
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND="dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README"

xfce44_goodies_panel_plugin
