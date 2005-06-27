# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2003/ut2003-2225-r3.ebuild,v 1.3 2005/06/27 22:33:25 wolf31o2 Exp $

inherit games

DESCRIPTION="Unreal Tournament 2003 - Sequel to the 1999 Game of the Year multi-player first-person shooter"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="http://unreal.epicgames.com/linux/ut2003/${PN}lnx_2107to${PV}.sh.bin
	ftp://david.hedbor.org/ut2k3/updates/${PN}lnx_2107to${PV}.sh.bin
	http://download.factoryunreal.com/mirror/UT2003CrashFix.zip"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="x86"
IUSE="dedicated"
RESTRICT="nostrip"

DEPEND="virtual/libc
	app-arch/unzip
	games-util/uz2unpack
	games-util/loki_patch"
RDEPEND="dedicated? ( games-server/ut2003-ded )
	!dedicated? ( virtual/opengl )"

S="${WORKDIR}"

dir="${GAMES_PREFIX_OPT}/${PN}"

pkg_setup() {
	check_license || die "License check failed"
	ewarn "The installed game takes about 2.7GB of space!"
	cdrom_get_cds System/Packages.md5 StaticMeshes/AWHardware.usx.uz2 \
		Extras/MayaPLE/Maya4PersonalLearningEditionEpic.exe
	games_pkg_setup
}

src_unpack() {
	unpack_makeself ${DISTDIR}/${PN}lnx_2107to${PV}.sh.bin \
		|| die "unpacking patch"
	unzip ${DISTDIR}/UT2003CrashFix.zip \
		|| die "unpacking crash-fix"
}

src_install() {
	local Ddir="${D}/${dir}"

	dodir ${dir}/System

	# Disk 1
	einfo "Copying files from Disk 1..."
	cp -r ${CDROM_ROOT}/{Animations,ForceFeedback,Help,KarmaData,Maps,Sounds,Textures,Web} ${Ddir} || die "copying files"
	cp -r ${CDROM_ROOT}/System/{editorres,*.{bmp,dat,det,est,frt,ini,int,itt,md5,u,upl,url}} ${Ddir}/System || die "copying files"
	mkdir -p ${Ddir}/Benchmark/Stuff || die "creating benchamrk folders"
	cp -r ${CDROM_ROOT}/Benchmark/Stuff/* ${Ddir}/Benchmark/Stuff || die "copying benchmark files"
	cdrom_load_next_cd

	# Disk 2
	einfo "Copying files from Disk 2..."
	cp -r ${CDROM_ROOT}/{Music,Sounds,StaticMeshes,Textures} ${Ddir} || die "copying files"
	cdrom_load_next_cd

	# Disk 3
	einfo "Copying files from Disk 3..."
	cp -r ${CDROM_ROOT}/Sounds ${Ddir} || die "copying files"

	# create empty files in Benchmark
	for j in {CSVs,Logs,Results} ; do
		mkdir -p ${Ddir}/Benchmark/${j} || die "creating folders"
		touch ${Ddir}/Benchmark/${j}/DO_NOT_DELETE.ME || die "creating files"
	done

	# remove Default, DefUser, UT2003 and User ini files
	rm ${Ddir}/System/{Def{ault,User},UT2003,User}.ini || die "deleting ini files"

	# unpack_makeself won't take absolute path
	unpack_makeself ${CDROM_ROOT}/linux_installer.sh || die "unpacking linux installer"

	# install extra help files
	insinto ${dir}/Help
	doins ${S}/Help/Unreal.bmp

	# install Default and DefUser ini files
	insinto ${dir}/System
	doins ${S}/System/Def{ault,User}.ini

	# install eula
	insinto ${dir}
	doins ${S}/eula/License.int

	# uncompress original binaries/libraries
	tar -xf ut2003lnxbins.tar || die "unpacking original binaries/libraries"

	# copying extra/updater
	cp -r ${S}/{extras,updater} ${Ddir} || die "copying extras/updater"

	# install benchmarks
	cp -r ${S}/Benchmark ${Ddir} || die "copying benchmark files"

	# copy ut2003/ucc
	exeinto ${dir}
	doexe ${S}/bin/ut2003 ${S}/ucc || die "copying ut2003/ucc"

	# copy binaries/libraries
	exeinto ${dir}/System
	doexe ${S}/System/{*-bin,*.so.0,*.so} || die "copying system binaries/libraries"

	# uncompressing files
	einfo "Uncompressing files... this may take a while..."
	for j in {Animations,Maps,Sounds,StaticMeshes,Textures} ; do
		games_ut_unpack ${Ddir}/${j} || die "uncompressing files"
	done

	# installing documentation/icon
	dodoc ${S}/README.linux || die "dodoc README.linux"
	insinto /usr/share/pixmaps ; newins ${S}/Unreal.xpm UT2003.xpm || die "copying pixmap"
	insinto ${dir}
	doins ${S}/README.linux ${S}/Unreal.xpm || die "copying readme/icon"

	games_make_wrapper ut2003 ./ut2003 ${dir}

	# this brings our install up to the newest version
	cd ${S}
	loki_patch --verify patch.dat || die "verifying patch"
	loki_patch patch.dat ${Ddir} >& /dev/null || die "patching"

	# Here we apply DrSiN's crash patch
	cp ${S}/CrashFix/System/crashfix.u ${Ddir}/System

	ed ${Ddir}/System/Default.ini >/dev/null 2>&1 <<EOT
$
?Engine.GameInfo?
a
AccessControlClass=crashfix.iaccesscontrolini
.
w
q
EOT

	# Here we apply fix for bug #54726
	dosed "s:UplinkToGamespy=True:UplinkToGamespy=False:" \
		${dir}/System/Default.ini

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find ${Ddir} -exec touch '{}' \;

	prepgamesdirs
	make_desktop_entry ut2003 "Unreal Tournament 2003" UT2003.xpm
}

pkg_postinst() {
	games_pkg_postinst

	# here is where we check for the existence of a cdkey...
	# if we don't find one, we ask the user for it
	if [ -f ${dir}/System/cdkey ]; then
		einfo "A cdkey file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
		ewarn "That way you can [re]enter your cdkey."
	fi
	echo
	einfo "To play the game run:"
	einfo " ut2003"
	echo
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${dir}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here."
	ewarn "  Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXX-XXXX-XXXX-XXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read CDKEY1
		einfo "Please re-enter your CD key:"
		read CDKEY2
		if [ "$CDKEY1" == "" ] ; then
			echo "You entered a blank CD key.  Try again."
		else
			if [ "$CDKEY1" == "$CDKEY2" ] ; then
				echo "$CDKEY1" | tr a-z A-Z > ${dir}/System/cdkey
				einfo "Thank you!"
				chown games:games ${dir}/System/cdkey
				break
			else
				eerror "Your CD key entries do not match.  Try again."
			fi
		fi
	done
}
