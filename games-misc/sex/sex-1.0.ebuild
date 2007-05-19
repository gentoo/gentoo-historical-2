# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/sex/sex-1.0.ebuild,v 1.15 2007/05/19 16:38:38 welp Exp $

inherit games

DESCRIPTION="Spouts silly mad-lib-style porn-like text"
HOMEPAGE="http://spatula.net/software/sex/"
SRC_URI="http://spatula.net/software/sex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc-macos ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	rm -f ${S}/Makefile
}

src_compile() {
	emake sex || die "emake failed"
}

src_install() {
	dogamesbin sex || die "dogamesbin failed"
	doman sex.6
	dodoc README
	prepgamesdirs
}
