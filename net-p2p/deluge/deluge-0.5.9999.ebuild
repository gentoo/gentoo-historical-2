# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/deluge/deluge-0.5.9999.ebuild,v 1.1 2008/06/12 15:44:35 armin76 Exp $

inherit eutils distutils subversion flag-o-matic

ESVN_REPO_URI="http://svn.deluge-torrent.org/trunk/"
ESVN_PROJECT="deluge"

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://deluge-torrent.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="libnotify"

DEPEND=">=dev-lang/python-2.3
	dev-libs/boost"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2
	dev-python/pyxdg
	dev-python/dbus-python
	gnome-base/librsvg
	libnotify? ( dev-python/notify-python )"

pkg_setup() {
	if ! built_with_use --missing true "dev-libs/boost" threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi

	filter-ldflags -Wl,--as-needed
}

pkg_postinst() {
	elog
	elog "If after upgrading it doesn't work, please remove the"
	elog "'~/.config/deluge' directory and try again, but make a backup"
	elog "first!"
	elog
	elog "Please note that Deluge is still in it's early stages"
	elog "of development. Use it carefully and feel free to submit bugs"
	elog "in upstream page."
	elog
}
