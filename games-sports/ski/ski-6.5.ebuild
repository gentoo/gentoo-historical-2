# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/ski/ski-6.5.ebuild,v 1.4 2004/11/05 05:41:20 josejx Exp $

inherit games

DESCRIPTION="A simple text-mode skiing game"
HOMEPAGE="http://www.catb.org/~esr/ski/"
SRC_URI="http://www.catb.org/~esr/ski/${P}.tar.gz"

KEYWORDS="x86 ~amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-lang/python"

src_install() {
	dogamesbin ski || die "dogamesbin failed"
	doman ski.6    || die "doman failed"
	dodoc README   || die "dodoc failed"
	prepgamesdirs
}
