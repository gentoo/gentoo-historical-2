# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-kde-client/ggz-kde-client-0.0.9.ebuild,v 1.1 2004/12/27 00:36:40 vapier Exp $

inherit kde

DESCRIPTION="The kde client for GGZ Gaming Zone"
HOMEPAGE="http://ggz.sourceforge.net/"
SRC_URI="http://ftp.ggzgamingzone.org/pub/ggz/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=dev-games/ggz-client-libs-${PV}"

need-kde 3
