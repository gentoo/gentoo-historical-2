# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/unreal-tournament-strikeforce/unreal-tournament-strikeforce-1.81.ebuild,v 1.3 2003/10/03 10:11:55 mr_bones_ Exp $

inherit games

MY_PV=${PV/./}
DESCRIPTION="A UT addon where you fight terrorists as part of an elite strikeforce"
HOMEPAGE="http://www.strike-force.com/"
SRC_URI="http://strikeforce.redconcepts.net/sf_180_server_files.tar.gz
	mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/sf180lnx.zip"
#http://www.hut.fi/~kalyytik/sf/linux-sf.html

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

DEPEND="|| ( games-fps/unreal-tournament games-fps/unreal-tournament-goty )"

S="${WORKDIR}"

src_unpack() {
	unpack sf_180_server_files.tar.gz
	unpack ${P}.tar.bz2
	unpack sf180lnx.zip
	mv "README - sf orm mappack.txt" Strikeforce/SFDoc/
	rm -rf Help/OpenGL\ Alternate
	rm System/*.{dll,lnk,exe} System/ServerAdds.zip
	rm Strikeforce/SF_System/*.bat
	find -type f -exec chmod a-x '{}' \;
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/unreal-tournament
	dodir ${dir}
	mv * ${D}/${dir}/
	prepgamesdirs
}
