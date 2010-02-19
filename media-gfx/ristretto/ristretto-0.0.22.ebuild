# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/ristretto/ristretto-0.0.22.ebuild,v 1.3 2010/02/19 20:00:17 ssuominen Exp $

inherit fdo-mime gnome2-utils

DESCRIPTION="Image viewer and browser for Xfce4"
HOMEPAGE="http://goodies.xfce.org/projects/applications/ristretto"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

RDEPEND="media-libs/libexif
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.12
	dev-libs/dbus-glib
	<xfce-base/thunar-1.1.0
	>=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_compile() {
	local myconf="--disable-dependency-tracking"

	if has_version ">=xfce-base/xfdesktop-4.5"; then
		myconf+=" --enable-xfce-desktop"
	fi

	econf ${myconf} $(use_enable debug)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
