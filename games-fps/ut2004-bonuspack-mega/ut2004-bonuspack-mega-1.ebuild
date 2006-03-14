# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-bonuspack-mega/ut2004-bonuspack-mega-1.ebuild,v 1.1 2006/03/14 22:53:34 wolf31o2 Exp $

inherit games games-ut2k4mod

MY_P="ut2004megapack-linux.tar.bz2"
MY_PN="Megapack"

DESCRIPTION="Unreal Tournament 2004 - Megapack bonus pack"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/Missions/${MY_P}
	http://0day.icculus.org/ut2004/${MY_P}
	ftp://ftp.games.skynet.be/pub/misc/${MY_P}
	http://sonic-lux.net/data/mirror/ut2004/${MY_P}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="nostrip nomirror"
IUSE=""

# Override games-ut2k4mod eclass
# File comparison was made with ut2004-3369-r2
RDEPEND=">=games-fps/ut2004-3369-r2
	games-fps/ut2004-data
	games-fps/ut2004-bonuspack-ece"
DEPEND="${RDEPEND}"

S=${WORKDIR}/UT2004MegaPack
dir=${GAMES_PREFIX_OPT}/ut2004
Ddir=${D}/${dir}

src_unpack() {
	# Override games-ut2k4mod
	unpack ${A}
}

src_install() {
	# The already-installed files are identical, except:
	# System/Manifest.ini, System/Manifest.int, System/Packages.md5

	# Remove files in Megapack which are already installed
	rm -r Animations Speech Web

	rm Help/{ReadMePatch.int.txt,UT2004Logo.bmp}
	mv Help/BonusPackReadme.txt Help/${MY_PN}Readme.txt

	rm Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2
	rm Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx

	# System
	rm System/{AL,AS-,B,b,C,D,E,F,G,I,L,O,o,S,s,U,V,W,X,x}*
	rm System/{ucc,ut2004}-bin
	rm System/{ucc,ut2004}-bin-linux-amd64

	# Handle the changed files gracefully
	for n in {Manifest.in{i,t},Packages.md5} ; do
		mv System/${n} System/${n}-${MY_PN}
	done

	rm Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S,HourAdaraTexor,jwfasterfiles,ONSBP_DestroyedVehicles,ONSBPTextures,PC_UrbanTex,UT2004ECEPlayerSkins}.utx

	# Install Megapack
	for n in {Help,Maps,Music,Sounds,StaticMeshes,System,Textures} ; do
		# doins is not used because of its unnecessary overhead
		dodir "${dir}"/${n}
		cp -r "${S}"/${n}/* "${Ddir}"/${n} \
			|| die "copying ${n} from ${MY_PN}"
	done

	prepgamesdirs
}

pkg_postinst() {
	local sysdir=${dir}/System
	local mfile=${sysdir}/Manifest.ini

	# DM-BP2-GoopGod is a map from the Megapack
	if [[ ! -e "${mfile}" ]] || \
		[[ $(grep -c "DM-BP2-GoopGod.ut2," "${mfile}") = "0" ]] ; then
		# Make the changed files live
		for n in {Manifest.in{i,t},Packages.md5} ; do
			einfo "Installing ${sysdir}/${n}"
			cp -p "${sysdir}"/${n}-${MY_PN} "${sysdir}"/${n} \
				|| die "cp ${n}-${MY_PN} failed"
		done
		echo
	fi

	games_pkg_postinst
}
