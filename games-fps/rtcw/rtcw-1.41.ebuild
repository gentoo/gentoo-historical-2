# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="Return to Castle Wolfenstein - Long awaited sequel to Wolfenstein 3D"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/wolf/linux/wolf-linux-1.4-full.x86.run
	ftp://3dgamers.in-span.net/pub/3dgamers3/games/returnwolfenstein/wolf-linux-1.4-full.x86.run
	ftp://ftp.idsoftware.com/idstuff/wolf/linux/wolf-linux-update-${PV}.x86.run
	ftp://3dgamers.in-span.net/pub/3dgamers3/games/returnwolfenstein/wolf-linux-update-${PV}.x86.run"

HOMEPAGE="http://games.activision.com/games/wolfenstein/"

LICENSE="RTCW"
SLOT="0"
KEYWORDS="x86"
RESTRICT="nostrip"
IUSE="opengl dedicated"

DEPEND="virtual/glibc"
RDEPEND="dedicated? ( app-misc/screen )
	!dedicated? ( virtual/opengl )
	opengl? ( virtual/opengl )"

S=${WORKDIR}

src_unpack() {
	unpack_makeself wolf-linux-1.4-full.x86.run
	unpack_makeself wolf-linux-update-${PV}.x86.run
#	tail +179 ${DISTDIR}/wolf-linux-1.4-full.x86.run | gzip -cd | tar xf - || die "full"
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir}

	cp -r main Docs pb ${D}/${dir}/

	exeinto ${dir}
	doexe bin/x86/*.x86 ${FILESDIR}/wolf-ded openurl.sh
	dosed "s:GENTOO_DIR:${dir}:" ${dir}/wolf-ded
	dogamesbin ${FILESDIR}/wolf ${FILESDIR}/wolf-ded
	dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/wolf
	dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/wolf-ded

	exeinto /etc/init.d
	newexe ${FILESDIR}/wolf-ded.rc wolf-ded
	dosed "s:GENTOO_DIR:${dir}:" /etc/init.d/wolf-ded

	insinto ${dir}
	doins WolfMP.xpm WolfSP.xpm INSTALL QUICKSTART CHANGES RTCW-README-1.4.txt
	insinto /usr/share/pixmaps
	doins WolfMP.xpm

	prepgamesdirs
	make_desktop_entry wolf "RtCW" WolfMP.xpm
}

pkg_postinst() {
	einfo "You need to copy pak0.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3,"
	einfo "sp_pak1.pk3 and sp_pak2.pk3 from a Window installation into ${dir}/main/"
	echo
	einfo "To play the game run:"
	einfo " wolf"
	if [ "`use dedicated`" ];
	then
		echo
		einfo "To start a dedicated server run:"
		einfo " /etc/init.d/wolf-ded start"
		echo
		einfo "To run the dedicated server at boot, type:"
		einfo " rc-update add wolf-ded default"
		echo
		einfo "The dedicated server is started under the ${GAMES_USER_DED} user account"
	fi
	games_pkg_postinst
}
