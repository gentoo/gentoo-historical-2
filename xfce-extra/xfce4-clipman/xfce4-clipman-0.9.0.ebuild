# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-clipman/xfce4-clipman-0.9.0.ebuild,v 1.1 2009/01/18 23:19:00 angelos Exp $

inherit xfce44

xfce44

DESCRIPTION="a simple cliboard history manager for Xfce4 Panel"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DOCS="AUTHORS ChangeLog README THANKS"

xfce44_goodies_panel_plugin
