# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/verve/verve-0.3.5.ebuild,v 1.8 2007/03/08 22:26:02 gustavoz Exp $

inherit xfce44

xfce44

DESCRIPTION="Command line panel plugin"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 sparc ~x86"
IUSE="dbus debug"

RDEPEND=">=xfce-extra/exo-0.3.2
	dev-libs/libpcre
	dbus? ( || ( dev-libs/dbus-glib <sys-apps/dbus-1 ) )"
DEPEND="${RDEPEND}
	dev-util/intltool"

xfce44_goodies_panel_plugin
