# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hoh-bin/hoh-bin-1.01.ebuild,v 1.6 2005/08/23 19:18:23 wolf31o2 Exp $

inherit games

S="${WORKDIR}/hoh-install-${PV}"
DESCRIPTION="PC remake of the spectrum game"
HOMEPAGE="http://retrospec.sgn.net/games/hoh/"
SRC_URI="http://retrospec.sgn.net/download.php?id=63\&path=games/hoh/bin/hohlin-${PV/./}.tar.bz2"

RESTRICT="nostrip"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/x11
	amd64? ( >=app-emulation/emul-linux-x86-xlibs-1.0 )"

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
	cp -pPRf data/* "${D}/${DATADIR}/" || die "cp failed (data)"
	cp -pPRf docs/* "${D}/${DOCDIR}/"  || die "cp failed (docs)"
	prepgamesdirs
}
