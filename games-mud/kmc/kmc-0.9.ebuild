# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/kmc/kmc-0.9.ebuild,v 1.8 2004/12/21 12:00:22 absinthe Exp $

inherit kde flag-o-matic

append-flags -fpermissive

DESCRIPTION="A mud client for KDE"
HOMEPAGE="http://kmc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"

SLOT="0"
IUSE=""

RDEPEND=">=dev-lang/perl-5.4"
need-kde 3
