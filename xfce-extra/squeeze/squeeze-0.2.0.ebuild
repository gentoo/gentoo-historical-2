# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/squeeze/squeeze-0.2.0.ebuild,v 1.4 2007/04/16 16:36:54 opfer Exp $

inherit xfce44

xfce44

DESCRIPTION="Archive manager"
HOMEPAGE="http://squeeze.xfce.org"
SRC_URI="http://${PN}.xfce.org/downloads/${P}${COMPRESS}"

KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="debug doc"

RESTRICT="test"

RDEPEND=">=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	>=xfce-base/thunar-${THUNAR_MASTER_VERSION}
	dev-libs/dbus-glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
