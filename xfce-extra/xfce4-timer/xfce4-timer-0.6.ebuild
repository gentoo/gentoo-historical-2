# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-timer/xfce4-timer-0.6.ebuild,v 1.9 2008/11/04 01:00:27 vapier Exp $

inherit xfce44

xfce44

DESCRIPTION="Timer panel plugin"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND="dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

xfce44_goodies_panel_plugin
