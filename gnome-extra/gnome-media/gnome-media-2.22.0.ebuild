# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.22.0.ebuild,v 1.5 2008/05/08 14:02:38 eva Exp $

EAPI="1"

inherit gnome2 eutils autotools

DESCRIPTION="Multimedia related programs for the GNOME desktop"
HOMEPAGE="http://ronald.bitfreak.net/gnome-media.php"

LICENSE="GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE="esd gnomecd ipv6"

RDEPEND=">=dev-libs/glib-1.3.7
	>=gnome-base/libgnome-2.13.7
	>=gnome-base/libgnomeui-2.13.2
	esd? ( >=media-sound/esound-0.2.23 )
	>=gnome-base/libbonobo-2
	>=x11-libs/gtk+-2.10
	>=media-libs/gstreamer-0.10.3
	>=media-libs/gst-plugins-base-0.10.3
	>=media-libs/gst-plugins-good-0.10
	>=gnome-base/gnome-vfs-2
	>=gnome-base/orbit-2
	gnomecd? (
		>=gnome-extra/nautilus-cd-burner-2.12
		>=gnome-base/gail-0.0.3 )
	>=gnome-base/libglade-2
	dev-libs/libxml2
	>=gnome-base/gconf-2
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.1"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35.0"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable esd vumeter)
		$(use_enable gnomecd)
		$(use_enable ipv6)
		--disable-esdtest
		--disable-scrollkeeper
		--disable-schemas-install"
}

src_unpack() {
	gnome2_src_unpack

	# Allow building without esound
	epatch "${FILESDIR}"/${PN}-2.18.0-noesd.patch
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If you cannot play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}
