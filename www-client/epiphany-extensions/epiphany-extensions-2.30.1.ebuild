# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany-extensions/epiphany-extensions-2.30.1.ebuild,v 1.7 2010/10/17 15:39:01 armin76 Exp $

EAPI="2"

inherit gnome2 eutils versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="dbus examples pcre"

RDEPEND=">=www-client/epiphany-${MY_MAJORV}
	app-text/opensp
	>=dev-libs/glib-2.15.5
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.6
	>=x11-libs/gtk+-2.19.5
	>=net-libs/webkit-gtk-1.1

	dbus? ( >=dev-libs/dbus-glib-0.34 )
	pcre? ( >=dev-libs/libpcre-3.9-r2 )"
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
# FIXME: - session-saver  ( https://bugzilla.gnome.org/show_bug.cgi?id=316245 )

pkg_setup() {
	local extensions=""

	extensions="actions auto-reload auto-scroller certificates \
			   error-viewer extensions-manager-ui gestures html5tube \
			   java-console livehttpheaders page-info permissions \
			   push-scroller select-stylesheet \
			   smart-bookmarks soup-fly tab-groups tab-states"
	use dbus && extensions="${extensions} rss"

	use pcre && extensions="${extensions} greasemonkey"

	use examples && extensions="${extensions} sample"

	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--with-extensions=$(echo "${extensions}" | sed -e 's/[[:space:]]\+/,/g')"
}

src_prepare() {
	gnome2_src_prepare

	# Updated Spanish translation, fixes bug #323753
	epatch "${FILESDIR}/${P}-fix-es_ES.patch"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
