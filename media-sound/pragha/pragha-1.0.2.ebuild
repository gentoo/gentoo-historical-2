# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pragha/pragha-1.0.2.ebuild,v 1.2 2012/06/18 19:56:54 ssuominen Exp $

EAPI=4
inherit xfconf

DESCRIPTION="A lightweight music player (with support for the Xfce desktop environment)"
HOMEPAGE="http://pragha.wikispaces.com/ http://github.com/matiasdelellis/pragha"
SRC_URI="mirror://github/matiasdelellis/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +glyr lastfm +playlist"

COMMON_DEPEND="dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.24
	>=dev-libs/keybinder-0.2.2
	>=dev-libs/libcdio-0.78
	media-libs/gst-plugins-base:0.10
	>=media-libs/libcddb-1.3.2
	>=media-libs/taglib-1.7.1
	>=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=x11-libs/libnotify-0.7
	>=xfce-base/libxfce4ui-4.8
	playlist? ( >=dev-libs/totem-pl-parser-2.26 )
	glyr? ( >=media-libs/glyr-0.9.9 )
	lastfm? ( >=media-libs/libclastfm-0.5 )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:0.10"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable lastfm libclastfm)
		$(use_enable glyr libglyr)
		$(use_enable playlist totem-plparser)
		)
}

src_prepare() {
	sed -i -e '/CFLAGS/s:-g -ggdb -O0::' configure || die
	xfconf_src_prepare
}
