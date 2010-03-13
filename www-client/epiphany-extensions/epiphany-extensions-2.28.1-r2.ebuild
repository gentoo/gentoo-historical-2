# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany-extensions/epiphany-extensions-2.28.1-r2.ebuild,v 1.1 2010/03/13 11:14:57 pacho Exp $

EAPI="2"

inherit gnome2 eutils versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus examples"

RDEPEND=">=www-client/epiphany-${MY_MAJORV}
	app-text/opensp
	>=dev-libs/glib-2.15.5
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.6
	>=x11-libs/gtk+-2.12.0
	>=gnome-base/libglade-2
	>=net-libs/webkit-gtk-1.1

	dbus? ( >=dev-libs/dbus-glib-0.34 )"
#	pcre? ( >=dev-libs/libpcre-3.9-r2 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.20
	>=app-text/gnome-doc-utils-0.3.2"
# eautoreconf dependencies:
#	  gnome-base/gnome-common

DOCS="AUTHORS ChangeLog HACKING NEWS README"

# FIXME: Open security issues:
# FIXME: - adblock        ( https://bugzilla.gnome.org/show_bug.cgi?id=595255 )
# FIXME: broken extensions:
# FIXME: - gestures       ( https://bugzilla.gnome.org/show_bug.cgi?id=563099 )
# FIXME: - session-saver  ( https://bugzilla.gnome.org/show_bug.cgi?id=316245 )
# FIXME: - sidebar: hangs ( https://bugzilla.gnome.org/show_bug.cgi?id=594481 )
# FIXME: - greasemonkey	  ( https://bugzilla.gnome.org/show_bug.cgi?id=598434 )

pkg_setup() {
	local extensions=""

	extensions="actions auto-reload auto-scroller certificates \
			   error-viewer extensions-manager-ui \
			   java-console livehttpheaders page-info permissions \
			   push-scroller select-stylesheet \
			   smart-bookmarks soup-fly tab-groups tab-states"
	use dbus && extensions="${extensions} rss"

#	use pcre && extensions="${extensions} greasemonkey"

	use examples && extensions="${extensions} sample"

	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"
}

src_prepare() {
	gnome2_src_prepare
	# auto-scroller is broken and makes middle click be unable to open links in new tabs,
	# bug 294712
	epatch "${FILESDIR}/${P}-auto-scroller-broken.patch"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
