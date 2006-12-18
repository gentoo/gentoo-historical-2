# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/deskbar-applet/deskbar-applet-2.16.2.ebuild,v 1.6 2006/12/18 15:09:45 tgall Exp $

inherit gnome2 eutils autotools python

DESCRIPTION="An Omnipresent Versatile Search Interface"
HOMEPAGE="http://raphael.slinckx.net/deskbar/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="eds"

RDEPEND=">=dev-lang/python-2.4
		 >=x11-libs/gtk+-2.6
		 >=dev-python/pygtk-2.6
		 >=dev-python/gnome-python-2.10
		 >=gnome-base/gnome-desktop-2.10
		 >=sys-apps/dbus-0.60
		 >=dev-python/gnome-python-desktop-2.14.0
		 >=dev-python/gnome-python-extras-2.14
		 >=gnome-base/gconf-2
		 eds? ( >=gnome-extra/evolution-data-server-1.7.92 )"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35
		>=sys-devel/autoconf-2.60
		dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable eds evolution) --exec-prefix=/usr"
}

src_unpack() {
	gnome2_src_unpack

	# Fix installing libs into pythondir
	epatch ${FILESDIR}/${PN}-2.15.3-multilib.patch
	# Unset DISPLAY before tests; bug #148056
	epatch ${FILESDIR}/${PN}-2.16.1-display.patch

	AT_M4DIR="m4" eautoreconf
}
