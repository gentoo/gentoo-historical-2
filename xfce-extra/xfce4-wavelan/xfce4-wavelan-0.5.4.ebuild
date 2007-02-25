# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-wavelan/xfce4-wavelan-0.5.4.ebuild,v 1.2 2007/02/25 09:32:06 drac Exp $

inherit xfce44

xfce44
xfce44_gzipped
xfce44_goodies_panel_plugin

DESCRIPTION="Wireless monitor panel plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

RDEPEND=">=xfce-base/xfce4-panel-${XFCE_MASTER_VERSION}"
DEPEND="${RDEPEND}
	dev-util/intltool"
