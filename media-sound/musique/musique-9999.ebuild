# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musique/musique-9999.ebuild,v 1.1 2012/01/21 10:30:16 hwoarang Exp $

EAPI="4"

inherit qt4-r2 git-2

DESCRIPTION="Qt4 music player."
HOMEPAGE="http://flavio.tordini.org/minitunes"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/qt-gui:4[dbus]
	x11-libs/qt-sql:4[sqlite]
	|| ( x11-libs/qt-phonon:4 media-libs/phonon )
	media-libs/taglib
	!media-sound/minitunes
"
DEPEND="${RDEPEND}"

DOCS="CHANGES TODO"

src_configure() {
	eqmake4 ${PN}.pro PREFIX="/usr"
}
