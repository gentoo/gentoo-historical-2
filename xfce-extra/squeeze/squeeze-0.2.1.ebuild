# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/squeeze/squeeze-0.2.1.ebuild,v 1.4 2007/05/18 20:04:31 welp Exp $

inherit xfce44

xfce44

DESCRIPTION="Archive manager"
HOMEPAGE="http://squeeze.xfce.org"
SRC_URI="http://${PN}.xfce.org/downloads/${P}${COMPRESS}"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="debug doc"

RDEPEND=">=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	>=xfce-base/thunar-${THUNAR_MASTER_VERSION}
	dev-libs/dbus-glib
	app-arch/tar"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
