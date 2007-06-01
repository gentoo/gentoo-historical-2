# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4mcs/libxfce4mcs-4.4.1.ebuild,v 1.8 2007/06/01 00:01:22 ranger Exp $

inherit xfce44

XFCE_VERSION=4.4.1
xfce44

DESCRIPTION="Components library"
HOMEPAGE="http://www.xfce.org/projects/libraries"
KEYWORDS="alpha amd64 ~arm hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug doc startup-notification"

RDEPEND="x11-libs/libX11
	x11-libs/libSM
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	startup-notification? ( x11-libs/startup-notification )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

xfce44_core_package
