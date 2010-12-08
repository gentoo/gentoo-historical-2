# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/panflute/panflute-0.6.2.ebuild,v 1.2 2010/12/08 17:44:31 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"

inherit gnome2 python eutils versionator

MY_MAJORV="$(get_version_component_range 1-2)"

DESCRIPTION="GNOME applet to control various music players"
HOMEPAGE="http://launchpad.net/panflute"
SRC_URI="http://launchpad.net/${PN}/${MY_MAJORV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome libnotify mpd"

# This ebuild is far from perfect, it does a lot of automagic detection
RDEPEND="
	>=dev-python/dbus-python-0.80
	>=dev-libs/dbus-glib-0.71
	dev-python/pygobject
	gnome? (
		>=x11-libs/pango-1.6
		>=gnome-base/libgnomeui-2
		>=gnome-base/gnome-panel-2
		>=dev-python/gconf-python-2.14
		>=dev-python/gnome-keyring-python-2.14
		>=dev-python/gnome-applets-python-2.14
		>=dev-python/pygtk-2.16 )
	libnotify? ( dev-python/notify-python )
	mpd? ( >=dev-python/python-mpd-0.2.1 )
	!gnome-extra/music-applet
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README THANKS"
	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	python_convert_shebangs -r 2 .
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize panflute
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup panflute
}
