# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3/quake3-1.31.ebuild,v 1.13 2005/01/20 07:55:13 eradicator Exp $

inherit games

DESCRIPTION="Quake III Arena - 3rd installment of the classic id 3D first-person shooter"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-${PV}.x86.run"

LICENSE="Q3AEULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="X dedicated opengl"
RESTRICT="nostrip"

RDEPEND="virtual/libc
	opengl? ( virtual/opengl )
	X? ( virtual/x11 )
	dedicated? ( app-misc/screen )
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	check_license
	games_pkg_setup
}

src_unpack() {
	unpack_makeself
}

src_install() {
	dodir ${dir}

	insinto ${dir}/baseq3
	doins baseq3/*.pk3
	mv Help ${Ddir}/
	insinto ${dir}/missionpack
	doins missionpack/*.pk3

	exeinto ${dir}
	insinto ${dir}
	doexe bin/x86/{quake3.x86,q3ded}
	doins quake3.xpm README* Q3A_EULA.txt
	games_make_wrapper quake3 ./quake3.x86 ${dir}
	games_make_wrapper q3ded ./q3ded ${dir}

	exeinto /etc/init.d ; newexe ${FILESDIR}/q3ded.rc q3ded
	insinto /etc/conf.d ; newins ${FILESDIR}/q3ded.conf.d q3ded
	insinto /usr/share/pixmaps
	doins quake3.xpm

	prepgamesdirs
	make_desktop_entry quake3 "Quake III Arena" quake3.xpm
}

pkg_postinst() {
	games_pkg_postinst

	einfo "You need to copy pak0.pk3 from your Quake3 CD into ${dir}/baseq3."
	einfo "Or if you have got a Window installation of Q3 make a symlink to save space."
	echo
	einfo "To start a dedicated server, run"
	einfo "\t/etc/init.d/q3ded start"
	echo
	einfo "The dedicated server is started under the ${GAMES_USER_DED} user account."
}
