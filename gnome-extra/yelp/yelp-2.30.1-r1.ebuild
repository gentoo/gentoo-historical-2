# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.30.1-r1.ebuild,v 1.4 2010/08/01 11:50:08 fauli Exp $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="beagle lzma"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.19.1
	>=x11-libs/gtk+-2.18
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/dbus-glib-0.71
	beagle? ( || (
		>=dev-libs/libbeagle-0.3.0
		=app-misc/beagle-0.2* ) )
	net-libs/xulrunner:1.9
	sys-libs/zlib
	app-arch/bzip2
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma-utils ) )
	>=app-text/rarian-0.7
	>=app-text/scrollkeeper-9999"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	gnome-base/gnome-common"
# If eautoreconf:
#	gnome-base/gnome-common

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gecko=libxul-embedding
		$(use_enable lzma)"

	if use beagle; then
		G2CONF="${G2CONF} --with-search=beagle"
	else
		G2CONF="${G2CONF} --with-search=basic"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Fix automagic lzma support, bug #266128
	epatch "${FILESDIR}/${PN}-2.26.0-automagic-lzma.patch"

	# Fix build with xulrunner-1.9.2
	epatch "${FILESDIR}/${PN}-2.28.1-system-nspr.patch"

	# Fix TOC title I18N, bgo#615141
	epatch "${FILESDIR}/${P}-fix-toc.patch"

	# Fix "Open Link in New Window", bgo#615457
	epatch "${FILESDIR}/${P}-open-link.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	# strip stupid options in configure, see bug #196621
	sed -i 's|$AM_CFLAGS -pedantic -ansi|$AM_CFLAGS|' configure || die "sed	failed"
}
