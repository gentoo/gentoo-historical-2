# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/nwn-data/nwn-data-1.29.ebuild,v 1.7 2005/11/02 22:53:22 wolf31o2 Exp $

inherit eutils games

MY_PV=${PV//.}

DESCRIPTION="Neverwinter Nights Data Files"
HOMEPAGE="http://nwn.bioware.com/downloads/linuxclient.html"
SRC_URI="http://nwdownloads.bioware.com/neverwinternights/linux/${MY_PV}/nwclient${MY_PV}.tar.gz
	linguas_fr? (
		ftp://jeuxlinux.com/bioware/Neverwinter_Nights/nwfrench${MY_PV}.tar.gz )
	linguas_it? (
		http://nwdownloads.bioware.com/neverwinternights/linux/${MY_PV}/nwitalian${MY_PV}.tar.gz )
	linguas_es? (
		http://nwdownloads.bioware.com/neverwinternights/linux/${MY_PV}/nwspanish${MY_PV}.tar.gz )
	linguas_de? (
		http://xfer06.fileplanet.com/%5E389272944/082003/nwgerman${MY_PV}.tar.gz )
	nowin? (
		http://bsd.mikulas.com/nwresources${MY_PV}.tar.gz
		http://163.22.12.40/FreeBSD/distfiles/nwresources${MY_PV}.tar.gz
		ftp://jeuxlinux.com/bioware/Neverwinter_Nights/nwresources${MY_PV}.tar.gz )"

LICENSE="NWN-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nowin sou hou"
RESTRICT="nostrip nomirror"

RDEPEND="virtual/x11
	virtual/opengl
	>=media-libs/libsdl-1.2.5
	amd64? ( app-emulation/emul-linux-x86-baselibs )"

S=${WORKDIR}/nwn

GAMES_LICENSE_CHECK="yes"
dir=${GAMES_PREFIX_OPT}/nwn
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
	if use sou && use hou
	then
		echo "You will need the SoU and HoU CDs for this installation."
		cdrom_get_cds NWNSoUInstallGuide.rtf \
			ArcadeInstallNWNXP213f.EXE
	elif use sou
	then
		 echo "You will need the SoU CD for this installation."
		cdrom_get_cds NWNSoUInstallGuide.rtf
	elif use hou
	then
		 echo "You will need the HoU CD for this installation."
		cdrom_get_cds ArcadeInstallNWNXP213f.EXE
	fi
}

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unpack nwclient129.tar.gz
	cd "${WORKDIR}"
	use nowin && unpack nwresources129.tar.gz
	cd "${S}"
	rm -rf override/*
	# the following is so ugly, please pretend it doesnt exist
	declare -a Aarray=(${A})
	use nowin && if [ "${#Aarray[*]}" == "3" ]
	then
		unpack ${Aarray[1]}
	fi
	if use sou
	then
		unzip -o ${CDROM_ROOT}/Data_Shared.zip
		unzip -o ${CDROM_ROOT}/Language_data.zip
		unzip -o ${CDROM_ROOT}/Language_update.zip
		unzip -o ${CDROM_ROOT}/Data_Linux.zip
		rm -f data/patch.bif patch.key
	fi
	if use hou
	then
		if use sou && use hou
		then
			rm -f xp1patch.key data/xp1patch.bif override/*
			cdrom_load_next_cd
		fi
		rm -f data/patch.bif patch.key
		unzip -o ${CDROM_ROOT}/Data_Shared.zip
		unzip -o ${CDROM_ROOT}/Language_data.zip
		unzip -o ${CDROM_ROOT}/Language_update.zip
	fi
	sed -i -e '\:^./nwmain .*:i \
if [[ -f ./nwmouse.so ]]; then \
	export XCURSOR_PATH="$(pwd)" \
	export XCURSOR_THEME=nwmouse \
	export LD_PRELOAD=./nwmouse.so:$LD_PRELOAD \
fi \
	' "${S}/nwn"
}

src_install() {
	dodir "${dir}"
	# Since the movies don't play anyway, we'll remove them
	rm -rf "${S}"/movies
	mkdir -p "${S}"/dmvault "${S}"/hak "${S}"/portraits "${S}"/localvault
	rm -rf "${S}"/dialog.tlk "${S}"/dialog.TLK "${S}"/dmclient "${S}"/nwmain \
		"${S}"/nwserver  "${S}"/nwm/* "${S}"/SDL-1.2.5 "${S}"/fixinstall
	mv "${S}"/* "${Ddir}"
	keepdir ${dir}/servervault
	keepdir ${dir}/scripttemplates
	keepdir ${dir}/saves
	keepdir ${dir}/portraits
	keepdir ${dir}/hak
	cd ${Ddir}
	for d in ambient data dmvault hak localvault music override portraits
	do
		if [ -d ${d} ]
		then
			cd ${d}
			for f in $(find . -name '*.*') ; do
				lcf=$(echo ${f} | tr [:upper:] [:lower:])
				if [ ${f} != ${lcf} ] && [ -f ${f} ]
				then
					mv ${f} $(echo ${f} | tr [:upper:] [:lower:])
				fi
			done
			cd ${Ddir}
		fi
	done
	if ! use sou && ! use hou && use nowin
	then
		chmod a-x ${Ddir}/data/patch.bif ${Ddir}/patch.key
	fi
	doicon "${FILESDIR}"/nwn.png
	prepgamesdirs
	chmod -R g+rwX ${Ddir}/saves ${Ddir}/localvault ${Ddir}/dmvault \
		2>&1 > /dev/null || die "could not chmod"
	chmod g+rwX ${Ddir} || die "could not chmod"
}

pkg_postinst() {
	games_pkg_postinst
	if ! use nowin ; then
		einfo "The NWN linux client data is now installed."
		einfo "Proceed with the following steps in order to get it working:"
		einfo "1) Copy the following directories/files from your installed and"
		einfo "   patched (1.66) Neverwinter Nights to ${dir}:"
		einfo "    ambient/"
		einfo "    data/"
		einfo "    dmvault/"
		einfo "    hak/"
		einfo "    localvault/"
		einfo "    modules/"
		einfo "    music/"
		einfo "    portraits/"
		einfo "    saves/"
		einfo "    servervault/"
		einfo "    texturepacks/"
		einfo "    chitin.key"
		einfo "2) Remove some files to make way for the patch"
		einfo "    rm ${dir}/music/mus_dd_{kingmaker,shadowgua,witchwake}.bmu"
		einfo "    rm ${dir}/override/iit_medkit_001.tga"
		einfo "    rm ${dir}/data/patch.bif"
		if use sou
		then
			einfo "    rm ${dir}/xp1patch.key ${dir}/data/xp1patch.bif"
		fi
		if use hou
		then
			einfo "    rm ${dir}/xp2patch.key ${dir}/data/xp2patch.bif"
		fi
		einfo "3) Chown and chmod the files with the following commands"
		einfo "    chown -R ${GAMES_USER}:${GAMES_GROUP} ${dir}"
		einfo "    chmod -R g+rwX ${dir}"
		echo
		einfo "Or try emerging with USE=nowin"
	else
		einfo "The NWN linux client data is now installed."
	fi
	echo
	einfo "This is only the data portion, you will also need games-rpg/nwn to"
	einfo "play Neverwinter Nights."
	echo
}
