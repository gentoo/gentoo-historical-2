# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4util/libxfce4util-4.6.1.ebuild,v 1.11 2009/08/01 20:12:19 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="Basic utility library for Xfce4"
HOMEPAGE="http://www.xfce.org/projects/libraries"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.12:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
	DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"
}
