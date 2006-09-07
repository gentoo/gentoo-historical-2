# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-2.16.0.ebuild,v 1.1 2006/09/07 03:49:10 dang Exp $

inherit eutils gnome2 multilib autotools

DESCRIPTION="GNOME webbrowser based on the mozilla rendering engine"
HOMEPAGE="http://www.gnome.org/projects/epiphany/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc firefox python"

# require firefox on sparc and ia64, seamonkey on ppc64
RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.10
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/libglade-2.3.1
	>=gnome-base/gnome-vfs-2.9.2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=gnome-base/gnome-desktop-2.9.91
	>=x11-libs/startup-notification-0.5
	>=gnome-base/gconf-2
	>=app-text/iso-codes-0.35
	>=www-client/mozilla-firefox-1.5
	>=sys-apps/dbus-0.35
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygtk-2.7.1
		>=dev-python/gnome-python-2.6 )
	x11-themes/gnome-icon-theme"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	app-text/gnome-doc-utils
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	G2CONF="--disable-scrollkeeper \
		--with-mozilla=firefox \
		$(use_enable python)"
}

src_unpack() {
	gnome2_src_unpack

	epatch ${FILESDIR}/${PN}-1.9.2-broken-firefox.patch

	cp aclocal.m4 old_macros.m4
	AT_M4DIR=". ${S}/m4" WANT_AUTOCONF="2.5" \
	eautoreconf || die "Failed to reconfigure"
}

src_compile() {
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/xpti.dat
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/xpti.dat.tmp
	addpredict /usr/$(get_libdir)/mozilla-firefox/components/compreg.dat.tmp

	addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat
	addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat.tmp

	gnome2_src_compile
}
