# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/pauker/pauker-1.3.3.ebuild,v 1.5 2004/07/01 05:24:56 mr_bones_ Exp $

inherit games

MY_P="${PV}-jre14"
DESCRIPTION="A java based flashcard program"
HOMEPAGE="http://pauker.sourceforge.net"
SRC_URI="mirror://sourceforge/pauker/pauker-${MY_P}.jar"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4*
	virtual/x11
	virtual/libc"

src_unpack() {
	mkdir -p "${S}"
	cp "${DISTDIR}/${A}" "${S}" || die "cp failed"
}

src_install() {
	local jar="pauker.jar"
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	newins "${A}" ${jar} || die "newins failed"
	games_make_wrapper ${PN} "java -jar ./${jar}" "${GAMES_PREFIX_OPT}/${PN}"
	prepgamesdirs
}
