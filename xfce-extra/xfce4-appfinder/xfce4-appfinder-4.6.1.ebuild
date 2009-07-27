# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-appfinder/xfce4-appfinder-4.6.1.ebuild,v 1.9 2009/07/27 17:50:30 nixnut Exp $

EAPI="1"

inherit xfce4

xfce4_core

DESCRIPTION="Application finder"
HOMEPAGE="http://www.xfce.org/projects/xfce4-appfinder"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.6:2
	>=xfce-base/libxfce4menu-${XFCE_VERSION}
	>=xfce-base/libxfce4util-${XFCE_VERSION}
	>=xfce-base/libxfcegui4-${XFCE_VERSION}
	>=xfce-base/thunar-1"
DEPEND="${RDEPEND}
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"
