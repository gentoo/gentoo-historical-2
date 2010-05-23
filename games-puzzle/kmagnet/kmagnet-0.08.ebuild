# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/kmagnet/kmagnet-0.08.ebuild,v 1.3 2010/05/23 20:09:53 pacho Exp $

EAPI=2
KDE_LINGUAS="ca cs"
inherit kde4-base

DESCRIPTION="A simple puzzle game"
HOMEPAGE="http://www.kde-apps.org/content/show.php/kMagnet?content=109111"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/109111-${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug +handbook"

DEPEND=">=kde-base/libkdegames-${KDE_MINIMAL}"

DOCS="AUTHORS ChangeLog README TODO"
