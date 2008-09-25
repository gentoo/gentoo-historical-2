# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gvfs/gvfs-0.2.5.ebuild,v 1.7 2008/09/25 14:18:19 jer Exp $

inherit gnome2 eutils

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc64 sparc x86"
IUSE="avahi cdda doc fuse gnome gphoto2 hal gnome-keyring samba"

RDEPEND=">=dev-libs/glib-2.16
		 >=sys-apps/dbus-1.0
		 >=net-libs/libsoup-2.4
		 dev-libs/libxml2
		 net-misc/openssh
		 avahi? ( >=net-dns/avahi-0.6 )
		 cdda?  (
					>=sys-apps/hal-0.5.10
					>=dev-libs/libcdio-0.78.2
				)
		 fuse? ( sys-fs/fuse )
		 gnome? ( >=gnome-base/gconf-2.0 )
		 hal? ( >=sys-apps/hal-0.5.10 )
		 gphoto2? ( >=media-libs/libgphoto2-2.4 )
		 gnome-keyring? ( >=gnome-base/gnome-keyring-1.0 )
		 samba? ( >=net-fs/samba-3 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
			--enable-http
			--disable-obexftp
			--disable-archive
			$(use_enable avahi)
			$(use_enable cdda)
			$(use_enable fuse)
			$(use_enable gnome gconf)
			$(use_enable gphoto2)
			$(use_enable hal)
			$(use_enable gnome-keyring keyring)
			$(use_enable samba)"

	if use cdda && built_with_use dev-libs/libcdio minimal; then
		ewarn
		ewarn "CDDA support in gvfs requires dev-libs/libcdio to be built"
		ewarn "without the minimal USE flag."
		die "Please re-emerge dev-libs/libcdio without the minimal USE flag"
	fi
}
