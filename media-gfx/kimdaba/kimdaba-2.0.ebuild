# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kimdaba/kimdaba-2.0.ebuild,v 1.1.1.1 2005/11/30 09:37:22 chriswhite Exp $

inherit kde

DESCRIPTION="KDE Image Database (KimDaBa) is a tool for indexing, searching, and viewing images."
HOMEPAGE="http://ktown.kde.org/kimdaba/"
SRC_URI="http://ktown.kde.org/kimdaba/download/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

DEPEND="media-libs/libkipi
	|| ( kde-base/kdegraphics-kfile-plugins kde-base/kdegraphics )"
need-kde 3.2
