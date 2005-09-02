# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/control-center/control-center-2.10.2.ebuild,v 1.7 2005/09/02 19:43:11 hansmi Exp $

inherit eutils gnome2

DESCRIPTION="The gnome2 Desktop configuration tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~arm hppa ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="alsa gstreamer static"

MAKEOPTS="${MAKEOPTS} -j1"

RDEPEND=">=x11-libs/gtk+-2.4
	>=dev-libs/glib-2.5
	virtual/xft
	>=media-libs/fontconfig-1
	>=gnome-base/gconf-2
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2.2
	>=gnome-base/nautilus-2.6
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/gnome-desktop-2.2
	>=gnome-base/gnome-menus-2.9.1
	>=gnome-base/orbit-2
	media-sound/esound
	>=x11-wm/metacity-2.8.6-r1
	>=x11-libs/libxklavier-1.14
	!arm? ( alsa? ( >=media-libs/alsa-lib-0.9 ) )
	gstreamer? ( >=media-libs/gst-plugins-0.8 )
	!gnome-extra/fontilus
	!gnome-extra/themus
	!gnome-extra/acme"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF} --disable-schemas-install	--enable-vfs-methods \
$(use_enable alsa) $(use_enable gstreamer) $(use_enable static)"

USE_DESTDIR="1"

src_unpack() {

	unpack ${A}
	cd ${S}

	# See http://gcc.gnu.org/cgi-bin/gnatsweb.pl problem #9700 for
	# what this is about.
	use alpha && epatch ${FILESDIR}/control-center-2.2.0.1-alpha_hack.patch

	# Temporary workaround for a problematic behaviour with acme.
	epatch ${FILESDIR}/${PN}-2.6.0-remove-pmu.patch

	# Fix the logout keyboard shortcut by moving it out of
	# the control-center here, and into metacity, bug #52034
	epatch ${FILESDIR}/${PN}-2.9-logout.patch

	# Fix the hardcoding of tar, bzip2, and gzip paths in
	# gnome-theme-installer.  bug #84977
	epatch ${FILESDIR}/${PN}-2.10.1-pathfix.patch

}
