# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hoh-bin/hoh-bin-1.0.ebuild,v 1.3 2004/06/24 23:06:17 agriffis Exp $

inherit games

S="${WORKDIR}/hoh-install-1.0"
DESCRIPTION="PC remake of the spectrum game"
HOMEPAGE="http://retrospec.sgn.net/games/hoh/"
SRC_URI="http://retrospec.sgn.net/download.php?id=63\&path=games/hoh/bin/hohlin-${PV/./}.tar.bz2"

RESTRICT="nostrip"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/x11"

src_compile() {
	cat > "${T}/hoh" <<-EOF
		#!/bin/bash
		export LD_LIBRARY_PATH="${GAMES_PREFIX_OPT}/HoH/data/runtime"
		cd "${GAMES_PREFIX_OPT}/HoH/data"
		exec ./HoH \$@
EOF
}

src_install() {
	local DATADIR="${GAMES_PREFIX_OPT}/HoH/data"
	local DOCDIR="${GAMES_PREFIX_OPT}/HoH/docs"

	dogamesbin "${T}/hoh"            || die "dogames bin failed"
	dodir "${DATADIR}" "${DOCDIR}"   || die "dodir failed"
	cp -af data/* "${D}/${DATADIR}/" || die "cp failed (data)"
	cp -af docs/* "${D}/${DOCDIR}/"  || die "cp failed (docs)"
	prepgamesdirs
}
