# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/pychess/pychess-0.8.4.ebuild,v 1.3 2010/04/29 08:11:31 tupone Exp $
PYTHON_DEPEND="2"
EAPI="2"

inherit python games distutils

DESCRIPTION="A chess client for Gnome"
HOMEPAGE="http://pychess.googlepages.com/home"
SRC_URI="http://pychess.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gstreamer"

DEPEND="dev-python/pygtk
	dev-python/pygobject
	dev-python/pycairo
	dev-python/pysqlite
	gstreamer? ( dev-python/gst-python )
	dev-python/gnome-python-desktop
	x11-themes/gnome-icon-theme"

src_prepare() {
	python_convert_shebangs -r 2 .
}

pkg_setup() {
	python_set_active_version 2
	games_pkg_setup
}

src_install() {
	distutils_src_install --install-scripts="${GAMES_BINDIR}"
	dodoc AUTHORS README
	prepgamesdirs
}
