# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfcegui4/libxfcegui4-4.4.0.ebuild,v 1.4 2007/01/28 14:24:25 welp Exp $

inherit xfce44

xfce44

DESCRIPTION="Core library"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc startup-notification"

RDEPEND="x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/gtk+-2.6
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	startup-notification? ( x11-libs/startup-notification )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( dev-util/gtk-doc )
	!=xfce-base/xfce-mcs-plugins-4.3*
	!=xfce-base/xfce4-panel-4.3*"

DOCS="AUTHORS ChangeLog NEWS README TODO"

xfce44_core_package
