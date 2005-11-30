# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kimdaba/kimdaba-2.1.ebuild,v 1.1 2005/05/05 17:31:17 centic Exp $

inherit kde

#S="${WORKDIR}/${PN}-2005-03-28-noi18n"
DESCRIPTION="KDE Image Database (KimDaBa) is a tool for indexing, searching, and viewing images."
HOMEPAGE="http://ktown.kde.org/kimdaba/"
SRC_URI="http://ktown.kde.org/kimdaba/download/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE=""

DEPEND="media-libs/libkipi"
need-kde 3.2

