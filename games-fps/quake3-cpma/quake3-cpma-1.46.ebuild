# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-cpma/quake3-cpma-1.46.ebuild,v 1.2 2009/10/01 21:28:31 nyhm Exp $

MOD_DESC="advanced FPS competition mod"
MOD_NAME="Challenge Pro Mode Arena"
MOD_DIR="cpma"

inherit games games-mods

HOMEPAGE="http://www.promode.org/"
SRC_URI="http://www.challenge-tv.com/demostorage/files/cpm/cpma${PV//.}-nomaps.zip
	http://ftp1.srv.endpoint.nu/pub/repository/challenge-tv/demostorage/files/cpm/cpma${PV//.}-nomaps.zip
	http://www.promode.org/files/cpma-mappack-full.zip"

LICENSE="as-is"
KEYWORDS="-* ~amd64 ~ppc ~x86"
IUSE="dedicated opengl"

src_install() {
	insinto "${GAMES_DATADIR}/${GAME}/baseq3"
	doins "${WORKDIR}"/*.pk3 || die "pk3"

	games-mods_src_install
}

pkg_postinst() {
	games-mods_pkg_postinst
	elog " To enable bots add: +bot_enable 1"
}
