# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-data/ut2004-data-3186.ebuild,v 1.2 2005/02/24 01:58:40 wolf31o2 Exp $

inherit games games-ut2k4mod

DESCRIPTION="Unreal Tournament 2004 - This is the data portion of UT2004"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI=""

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="nostrip nomirror"
IUSE=""

DEPEND="games-util/uz2unpack"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/ut2004
Ddir=${D}/${dir}

pkg_setup() {
	check_dvd

	if [[ ${USE_DVD} -eq 1 ]]
	then
		DISK1="CD1/"
		DISK2="CD2/"
		DISK3="CD3/"
		DISK4="CD4/"
		DISK5="CD5/"
		DISK6="CD6/"
		if [[ ${USE_ECE_DVD} -eq 1 ]]
		then
			cdrom_get_cds ${DISK1}System/UT2004.ini \
				${DISK2}Textures/2K4Fonts.utx.uz2 \
				${DISK3}Textures/ONSDeadVehicles-TX.utx.uz2 \
				${DISK4}Textures/XGameShaders2004.utx.uz2 \
				${DISK5}Speech/ons.xml ${DISK6}/DirectX9/BDA.cab
		else
			cdrom_get_cds ${DISK1}/System/UT2004.ini \
				${DISK2}/Textures/2K4Fonts.utx.uz2 \
				${DISK3}/Textures/ONSDeadVehicles-TX.utx.uz2 \
				${DISK4}/Music/KR-UT2004-Menu.ogg \
				${DISK5}/Speech/ons.xml ${DISK6}/DirectX9/BDA.cab
		fi
	else
		cdrom_get_cds ${DISK1}/System/UT2004.ini \
			${DISK2}/Textures/2K4Fonts.utx.uz2 \
			${DISK3}/Textures/ONSDeadVehicles-TX.utx.uz2 \
			${DISK4}/Music/KR-UT2004-Menu.ogg \
			${DISK5}/Speech/ons.xml ${DISK6}/DirectX9/BDA.cab
	fi

	games_pkg_setup
}

src_unpack() {
	unpack_makeself ${CDROM_ROOT}/linux-installer.sh \
		|| die "unpacking linux installer"
	use x86 && tar -xf ${S}/linux-x86.tar
	use amd64 && tar -xf ${S}/linux-amd64.tar
}

src_install() {
	dodir ${dir}/System/editorres

	# Disk 1
	einfo "Copying files from Disk 1..."
	cp -r ${CDROM_ROOT}/${DISK1}{Animations,ForceFeedback,Help,KarmaData,Maps,Sounds,Web} ${Ddir} || die "copying files"
	cp -r ${CDROM_ROOT}/${DISK1}System/{editorres,*.{bat,bmp,dat,det,est,frt,ini,int,itt,kot,md5,smt,tmt,u,ucl,upl,url}} ${Ddir}/System || die "copying files"
	mkdir -p ${Ddir}/Manual || die "creating manual folder"
	cp ${CDROM_ROOT}/${DISK1}Manual/Manual.pdf ${Ddir}/Manual \
		|| die "copying manual"
	mkdir -p ${Ddir}/Benchmark/Stuff || die "creating benchmark folders"
	cp -r ${CDROM_ROOT}/${DISK1}Benchmark/Stuff/* ${Ddir}/Benchmark/Stuff \
		|| die "copying benchmark files"
	cdrom_load_next_cd

	# Disk 2
	einfo "Copying files from Disk 2..."
	cp -r ${CDROM_ROOT}/${DISK2}{Sounds,Textures} ${Ddir} || die "copying files"
	cdrom_load_next_cd

	# Disk 3
	einfo "Copying files from Disk 3..."
	cp -r ${CDROM_ROOT}/${DISK3}Textures ${Ddir} || die "copying files"
	cdrom_load_next_cd

	#Disk 4
	einfo "Copying files from Disk 4..."
	if [[ ${USE_ECE_DVD} -eq 1 ]]
	then
		cp -r ${CDROM_ROOT}/${DISK4}{StaticMeshes,Textures} ${Ddir} \
			|| die "copying files"
	else
		cp -r ${CDROM_ROOT}/${DISK4}{Music,StaticMeshes,Textures} ${Ddir} \
			|| die "copying files"
	fi
	cdrom_load_next_cd

	#Disk 5
	einfo "Copying files from Disk 5..."
	if [[ ${USE_ECE_DVD} -eq 1 ]]
	then
		cp -r ${CDROM_ROOT}/${DISK5}{Music,Sounds,Speech,StaticMeshes} ${Ddir} \
			|| die "copying files"
	else
		cp -r ${CDROM_ROOT}/${DISK5}{Music,Sounds,Speech} ${Ddir} \
			|| die "copying files"
	fi
	cdrom_load_next_cd

	#Disk 6
	einfo "Copying files from Disk 6..."
	cp -r ${CDROM_ROOT}/${DISK6}/Sounds ${Ddir} \
		|| die "copying files"

	# create empty files in Benchmark
	for j in {CSVs,Logs,Results}
	do
		mkdir -p ${Ddir}/Benchmark/${j} || die "creating folders"
		touch ${Ddir}/Benchmark/${j}/DO_NOT_DELETE.ME || die "creating files"
	done

	# install extra help files
	insinto ${dir}/Help
	doins ${S}/Unreal.bmp ${S}/UT2004Logo.bmp

	# install eula
	insinto ${dir}
	doins ${S}/UT2004_EULA.txt

	# install System.inis
	insinto ${dir}/System
	doins ${S}/ini-{det,est,frt,int,itt,kot,smt,tmt}.tar

	# copy ut2004
	exeinto ${dir}
	doexe ${S}/bin/ut2004 || die "copying ut2004"

	exeinto ${dir}/System
	doexe ${S}/System/{libSDL-1.2.so.0,openal.so,u{cc,t2004}-bin} \
		|| die "copying libs/ucc/ut2004"

	# uncompressing files
	einfo "Uncompressing files... this *will* take a while..."
	for j in {Animations,Maps,Sounds,StaticMeshes,Textures}
	do
		chmod -R u+w ${Ddir}/${j} || die "chmod in uncompress"
		games_ut_unpack ${Ddir}/${j} || die "uncompressing files"
	done

	# Removing unneccessary files in System and Help
	rm -f ${Ddir}/Help/{InstallerLogo.bmp,SAPI-EULA.txt,{Unreal,UnrealEd}.ico}
	rm -f ${Ddir}/System/*.tar
	rm -f ${Ddir}/System/{{License,Manifest}.smt,{ucc,StdOut}.log,{User,UT2004}.ini}

	# installing documentation/icon
	dodoc ${S}/README.linux || die "dodoc README.linux"
	insinto /usr/share/pixmaps;
	doins ${S}/ut2004.xpm || die "copying pixmap"
	insinto ${dir}
	doins ${S}/README.linux ${S}/ut2004.xpm || die "copying readme/icon"

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find ${Ddir} -exec touch '{}' \;

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	echo
	einfo "This is only the data portion of the game.  To play UT2004, you"
	einfo "still need to:"
	einfo " emerge ut2004."
	echo
}
