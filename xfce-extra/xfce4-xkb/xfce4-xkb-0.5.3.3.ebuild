# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-xkb/xfce4-xkb-0.5.3.3.ebuild,v 1.3 2009/07/20 15:44:52 ssuominen Exp $

inherit xfce4

XFCE_VERSION=4.4
xfce4_gzipped

DESCRIPTION="XKB layout switching panel plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
RDEPEND=">=x11-libs/libxklavier-3.2
	!>=x11-libs/libxklavier-4
	x11-libs/libwnck"
DEPEND="${RDEPEND}
	dev-util/intltool
	x11-proto/kbproto
	gnome-base/librsvg"

DOCS="AUTHORS ChangeLog NEWS README"

xfce4_panel_plugin
