# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-trigger-launcher/xfce4-trigger-launcher-4.2.0.ebuild,v 1.7 2005/02/08 23:55:02 kloeri Exp $

DESCRIPTION="Xfce 4 trigger launcher panel plugin"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 sparc x86"

BZIPPED=1
RDEPEND="~xfce-base/xfce4-panel-${PV}"

inherit xfce4