# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-diskperf/xfce4-diskperf-2.2.0.ebuild,v 1.11 2009/08/23 21:38:54 ssuominen Exp $

inherit xfce44

xfce44
xfce44_goodies_panel_plugin

DESCRIPTION="Disk usage and performance panel plugin"
HOMEPAGE="http://www.xfce.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="xfce-base/xfce4-panel"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"
