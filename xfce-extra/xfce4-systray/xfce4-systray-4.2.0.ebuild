# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-systray/xfce4-systray-4.2.0.ebuild,v 1.8 2005/03/12 20:24:02 vapier Exp $

DESCRIPTION="Xfce 4 system tray"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ~ppc64 sparc x86"

BZIPPED=1
RDEPEND=">=xfce-base/xfce4-panel-${PV}"

inherit xfce4
