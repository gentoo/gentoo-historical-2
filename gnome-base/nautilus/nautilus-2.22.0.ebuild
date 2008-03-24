# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-2.22.0.ebuild,v 1.1 2008/03/24 06:52:13 leio Exp $

inherit virtualx eutils gnome2

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/projects/nautilus/"
SRC_URI="${SRC_URI} http://dev.gentoo.org/~leio/distfiles/${P}-gentoo-patchset.tar.bz2"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="beagle gnome tracker"

RDEPEND=">=x11-libs/startup-notification-0.8
		 >=gnome-base/libbonobo-2.1
		 >=gnome-base/eel-2.21.90
		 >=dev-libs/glib-2.15.6
		 >=gnome-base/gnome-desktop-2.10
		 >=gnome-base/orbit-2.4
		 >=x11-libs/pango-1.1.2
		 >=x11-libs/gtk+-2.11.6
		 >=gnome-base/librsvg-2.0.1
		 >=dev-libs/libxml2-2.4.7
		 >=media-libs/libexif-0.5.12
		 >=gnome-base/gconf-2.0
		 >=gnome-base/gvfs-0.1.2
		 beagle? ( >=app-misc/beagle-0.0.12 )
		 tracker? ( >=app-misc/tracker-0.6.4 )
		 >=gnome-base/libgnome-2.14
		 >=gnome-base/libgnomeui-2.6"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/pkgconfig-0.9
		>=dev-util/intltool-0.35"
PDEPEND="gnome? ( >=x11-themes/gnome-icon-theme-1.1.91 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="--disable-update-mimedb $(use_enable beagle) $(use_enable tracker)"
}

src_unpack() {
	gnome2_src_unpack

	EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
}

src_test() {
	addwrite "/root/.gnome2_private"
	Xmake check || die "Test phase failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "nautilus can use gstreamer to preview audio files. Just make sure"
	elog "to have the necessary plugins available to play the media type you"
	elog "want to preview"
}
