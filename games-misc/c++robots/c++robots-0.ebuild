# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/c++robots/c++robots-0.ebuild,v 1.3 2004/04/28 18:26:11 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="ongoing 'King of the Hill' (KotH) tournament"
HOMEPAGE="http://www.gamerz.net/c++robots/"
SRC_URI="http://www.gamerz.net/c++robots/c++robots.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="static"

DEPEND="virtual/glibc"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/proper-coding.patch"
}

src_compile() {
	local myldflags="${LDFLAGS}"
	use static && myldflags="${myldflags} -static"
	emake CFLAGS="${CFLAGS}" LDFLAGS="${myldflags}" || die "emake failed"
}

src_install() {
	dogamesbin combat cylon target tracker || die "dogamesbin failed"
	dodoc README
	prepgamesdirs
}
