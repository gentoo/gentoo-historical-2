# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-bonuspack-ece/ut2004-bonuspack-ece-1-r3.ebuild,v 1.2 2007/01/10 19:37:56 wolf31o2 Exp $

MOD_DESC="Editor's Choice Edition bonus pack"
MOD_NAME="Editor's Choice Edition"

inherit games games-mods

MY_P="ut2004megapack-linux.tar.bz2"

HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/Missions/${MY_P}
	http://0day.icculus.org/ut2004/${MY_P}
	ftp://ftp.games.skynet.be/pub/misc/${MY_P}
	http://sonic-lux.net/data/mirror/ut2004/${MY_P}"

LICENSE="ut2003"

RDEPEND="games-fps/ut2004-data"

S=${WORKDIR}/UT2004MegaPack
dir=${GAMES_PREFIX_OPT}/${GAME}
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
}

src_unpack() {
	games-mods_src_unpack
	cd "${S}"
	# Remove megapack files which are not in ece
	rm Animations/ONSNewTank-A.ukx
	rm Help/ReadMePatch.int.txt
	# Help/{DebuggerLogo.bmp,InstallerLogo.bmp,Unreal.ico,UnrealEd.ico}
	# are not in megapack.
	# Keep new Help/UT2004Logo.bmp
	# Manual dir does not exist in megapack
	rm Maps/{AS*,CTF*,DM*}
	rm Sounds/A_Announcer_BP2.uax
	rm StaticMeshes/{JumpShipObjects.usx,Ty_RocketSMeshes.usx}
	rm System/{A*,b*,B*,CacheRecords.ucl,*.det,*.est,*.frt,*.itt,*.kot}
	rm System/{CTF*,D*,Editor*,G*,I*,L*,ONS-Arc*,Onslaught.*,*.md5}
	rm System/{u*,U*,V*,X*,Core.u,Engine.u,F*,*.ucl,Sk*}
	rm Textures/{J*,j*,T*}
	rm -r Web

	# The file lists of ut2004-3369-r1 and -r2 are identical
	# Remove files owned by ut2004-3369-r2
	rm Help/UT2004Logo.bmp
	# The 2 Manifest files have not changed
	rm System/{Manifest.in{i,t},OnslaughtFull.int}
	rm System/{Core.int,Engine.int,Setup.int,Window.int}
	rm System/{OnslaughtFull.u,OnslaughtBP.u}
}

src_install() {
	# Install Editor's Choice Edition
	for n in {Animations,Help,Maps,Sounds,StaticMeshes,System,Textures}
	do
		dodir "${dir}"/${n}
		cp -r "${S}"/${n}/* "${Ddir}"/${n} \
			|| die "copying ${n} from Editor's Choice Edition"
	done

	prepgamesdirs
}
