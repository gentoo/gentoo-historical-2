# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/liferea/liferea-1.4.16b.ebuild,v 1.1 2008/06/20 15:50:00 dang Exp $

WANT_AUTOMAKE=1.7
inherit gnome2 eutils autotools

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo/etc feeds"
HOMEPAGE="http://liferea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

EAPI="1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
# Can't add webkit until there's a masked use flag for it's keyworded
# webkit
IUSE="dbus gtkhtml gnutls libnotify lua networkmanager seamonkey xulrunner"

#	!xulrunner? ( webkit? ( net-libs/webkit-gtk ) )
#	!xulrunner? ( !webkit? ( seamonkey? ( =www-client/seamonkey-1* ) ) )
#	!amd64? ( !xulrunner? ( !webkit? ( ( !seamonkey? ( gtkhtml? ( gnome-extra/gtkhtml:2 ) ) ) ) ) )
RDEPEND="
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	lua? ( >=dev-lang/lua-5.1 )
	xulrunner? ( net-libs/xulrunner:1.9 )
	!xulrunner? ( ( seamonkey? ( =www-client/seamonkey-1* ) ) )
	!amd64? ( !xulrunner? ( !seamonkey? ( gtkhtml? ( gnome-extra/gtkhtml:2 ) ) ) )
	>=x11-libs/gtk+-2.8
	x11-libs/pango
	>=gnome-base/gconf-2
	>=dev-libs/libxml2-2.6.27
	>=dev-libs/libxslt-1.1.19
	>=dev-db/sqlite-3.3
	>=dev-libs/glib-2
	>=gnome-base/libglade-2
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	networkmanager? ( net-misc/networkmanager )
	gnutls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	# Backends are now mutually exclusive.
	# we prefer xulrunner over webkit over seamonkey over gtkhtml
	if use xulrunner ; then
		G2CONF="${G2CONF} --enable-xulrunner"
		G2CONF="${G2CONF} --disable-webkit"
		G2CONF="${G2CONF} --disable-gecko"
		G2CONF="${G2CONF} --disable-gtkhtml2"
#    elif use webkit ; then
#        G2CONF="${G2CONF} --enable-webkit"
#        G2CONF="${G2CONF} --disable-gecko"
#        G2CONF="${G2CONF} --disable-xulrunner"
#        G2CONF="${G2CONF} --disable-gtkhtml2"
	elif use seamonkey ; then
		G2CONF="${G2CONF} --enable-gecko=seamonkey"
		G2CONF="${G2CONF} --disable-xulrunner"
		G2CONF="${G2CONF} --disable-webkit"
		G2CONF="${G2CONF} --disable-gtkhtml2"
	elif use gtkhtml ; then
		if ! use amd64 ; then
			G2CONF="${G2CONF} --enable-gtkhtml2"
			G2CONF="${G2CONF} --disable-gecko"
			G2CONF="${G2CONF} --disable-xulrunner"
			G2CONF="${G2CONF} --disable-webkit"
		else
			elog ""
			elog "gtkhtml is no longer supported on amd64; you will need to "
			elog "select one of the gecko backends to use liferea.  "
			elog "Preference is: xulrunner, webkit, then seamonkey."
			die "You must enable one of the gecko backends or webkit on amd64"
		fi
	else
		elog ""
		elog "You must choose one backend for liferea to work.  Preference is:"
		elog "xulrunner, webkit, seamonkey, then gtkhtml."
		die "You must enable on of the backends"
	fi

	G2CONF="${G2CONF} \
		$(use_enable dbus) \
		$(use_enable gnutls) \
		$(use_enable libnotify) \
		$(use_enable lua) \
		$(use_enable networkmanager nm)"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${P}-xulrunner-1.9.patch
	eautoreconf
}

src_install() {
	gnome2_src_install
	rm -f "${D}/usr/bin/${PN}"
	mv "${D}/usr/bin/${PN}-bin" "${D}/usr/bin/${PN}"
}
