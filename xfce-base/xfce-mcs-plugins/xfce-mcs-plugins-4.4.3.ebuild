# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce-mcs-plugins/xfce-mcs-plugins-4.4.3.ebuild,v 1.4 2008/12/08 21:38:54 ranger Exp $

EAPI=1

inherit eutils xfce44

XFCE_VERSION=4.4.3

xfce44
xfce44_core_package

DESCRIPTION="Setting plugins"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="
	>=dev-libs/glib-2.6:2
	x11-apps/xrdb
	>=x11-libs/gtk+-2.6:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	>=xfce-base/libxfcegui4-${XFCE_MASTER_VERSION}
	>=xfce-base/xfce-mcs-manager-${XFCE_MASTER_VERSION}"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	x11-proto/inputproto
	x11-proto/xf86miscproto
	x11-proto/xf86vidmodeproto"

XFCE_CONFIG+=" --enable-xf86misc --enable-xkb --enable-xinput --enable-randr --enable-xf86vm"

DOCS="AUTHORS ChangeLog NEWS README"
