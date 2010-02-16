# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/xfburn/xfburn-0.4.3.ebuild,v 1.1 2010/02/16 17:03:32 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="GTK+ based CD and DVD burning application"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfburn"
SRC_URI="mirror://xfce/src/apps/${PN}/0.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus debug gstreamer hal"

RDEPEND=">=dev-libs/libburn-0.4.2
	>=dev-libs/libisofs-0.6.2
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfcegui4-4.4
	>=xfce-base/exo-0.3
	dbus? ( dev-libs/dbus-glib )
	gstreamer? ( media-libs/gstreamer
		>=media-libs/gst-plugins-base-0.10.20 )
	hal? ( sys-apps/hal )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable gstreamer)
		$(use_enable hal)
		--disable-thunar-vfs"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
