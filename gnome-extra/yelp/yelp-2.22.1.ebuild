# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.22.1.ebuild,v 1.1 2008/04/10 23:02:11 eva Exp $

inherit gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="beagle lzma xulrunner"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.11.1
	>=x11-libs/gtk+-2.10
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/glib-2
	>=dev-libs/dbus-glib-0.71
	beagle? ( >=app-misc/beagle-0.2.4 )
	!xulrunner? ( =www-client/mozilla-firefox-2* )
	xulrunner? ( =net-libs/xulrunner-1.8* )
	sys-libs/zlib
	app-arch/bzip2
	lzma? ( app-arch/lzma-utils )
	>=app-text/rarian-0.7
	>=app-text/scrollkeeper-9999"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# strip stupid options in configure, see bug #196621
	sed -i 's|$AM_CFLAGS -pedantic -ansi|$AM_CFLAGS|' configure
}

pkg_setup() {
	# FIXME: Add patch to make lzma-utils not automagic and use_enable here
	G2CONF="${G2CONF} --enable-man --enable-info"

	if use beagle; then
		G2CONF="${G2CONF} --with-search=beagle"
	else
		G2CONF="${G2CONF} --with-search=basic"
	fi

	if use xulrunner; then
		G2CONF="${G2CONF} --with-gecko=xulrunner"
	else
		G2CONF="${G2CONF} --with-gecko=firefox"
	fi
}
