# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/deluge/deluge-9999.ebuild,v 1.4 2007/07/26 10:45:25 armin76 Exp $

inherit eutils distutils subversion flag-o-matic

ESVN_REPO_URI="http://deluge-torrent.org/svn/trunk"
ESVN_PROJECT="deluge"

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://deluge-torrent.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="libnotify"

DEPEND=">=dev-lang/python-2.3
	dev-libs/boost"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2
	dev-python/pyxdg
	dev-python/dbus-python
	libnotify? ( dev-python/notify-python )"

pkg_setup() {
	if has_version "<dev-libs/boost-1.34" && \
		! built_with_use "dev-libs/boost" threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi
}

src_compile() {
	filter-ldflags -Wl,--as-needed

	distutils_src_compile
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
