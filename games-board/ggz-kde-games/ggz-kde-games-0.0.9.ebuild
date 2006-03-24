# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-kde-games/ggz-kde-games-0.0.9.ebuild,v 1.2 2006/03/24 16:28:42 wolf31o2 Exp $

inherit kde

DESCRIPTION="These are the kde versions of the games made by GGZ Gaming Zone"
HOMEPAGE="http://ggz.sourceforge.net/"
SRC_URI="http://ftp.ggzgamingzone.org/pub/ggz/${PV}/${P}.tar.gz
	http://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="~dev-games/ggz-client-libs-${PV}
	~games-board/ggz-kde-client-${PV}"

need-kde 3
