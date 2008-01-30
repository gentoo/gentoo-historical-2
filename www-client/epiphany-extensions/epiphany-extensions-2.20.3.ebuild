# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany-extensions/epiphany-extensions-2.20.3.ebuild,v 1.2 2008/01/30 14:58:14 eva Exp $

WANT_AUTOMAKE="1.10"
inherit eutils gnome2 autotools

DESCRIPTION="Extensions for the Epiphany web browser"
HOMEPAGE="http://www.gnome.org/projects/epiphany/extensions.html"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="pcre python xulrunner"

RDEPEND=">=www-client/epiphany-2.20
	>=dev-libs/libxml2-2.6
	>=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.11.6
	gnome-base/gconf
	>=gnome-base/libglade-2
	app-text/opensp
	xulrunner? ( net-libs/xulrunner )
	!xulrunner? ( >=www-client/mozilla-firefox-1.5 )
	pcre? ( >=dev-libs/libpcre-3.9-r2 )
	>=dev-libs/dbus-glib-0.71
	python? ( >=dev-python/pygtk-2.11 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_unpack() {
	gnome2_src_unpack

	# gnome bug #?
	epatch "${FILESDIR}"/${PN}-2.18.0-sessionsaver-v4.patch.gz

	echo "extensions/epilicious/progress.py" >> po/POTFILES.in
	echo "extensions/sessionsaver/ephy-sessionsaver-extension.c" >> po/POTFILES.in

	AT_M4DIR="m4" eautoreconf
}

pkg_setup() {
	local extensions="actions auto-reload auto-scroller certificates
	error-viewer extensions-manager-ui gestures java-console
	livehttpheaders page-info permissions push-scroller rss
	select-stylesheet sessionsaver sidebar smart-bookmarks tab-groups
	tab-states"

	use pcre && extensions="${extensions} greasemonkey adblock"

	use python && extensions="${extensions} python-console favicon
		cc-license-viewer epilicious"

	local list_exts=""
	for ext in $extensions; do
		[ "x${list_exts}" != "x" ] && list_exts="${list_exts},"
		list_exts="${list_exts}${ext}"
	done

	G2CONF="${G2CONF} --with-extensions=${list_exts}"
	if use xulrunner; then
		G2CONF="${G2CONF} --with-gecko=xulrunner"
	else
		G2CONF="${G2CONF} --with-gecko=firefox"
	fi
}
