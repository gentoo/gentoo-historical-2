# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/xfwm4-themes/xfwm4-themes-4.6.0.ebuild,v 1.4 2009/06/13 14:01:54 tcunha Exp $

inherit xfce4

xfce4_core

DESCRIPTION="Window manager themes"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="binchecks strip"

RDEPEND=">=xfce-base/xfwm4-${XFCE_VERSION}"

DOCS="AUTHORS ChangeLog NEWS README TODO"
