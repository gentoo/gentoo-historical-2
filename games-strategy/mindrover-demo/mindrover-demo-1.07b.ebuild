# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/mindrover-demo/mindrover-demo-1.07b.ebuild,v 1.1 2005/06/17 17:53:29 wolf31o2 Exp $

inherit eutils games

MY_P="mindrover_demo.run"
DESCRIPTION="Control a robot as it races across Europa"
HOMEPAGE="http://www.linuxgamepublishing.com/info.php?id=9"
SRC_URI=" http://demos.linuxgamepublishing.com/mindrover/${MY_P}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
RESTRICT="nostrip"

IUSE=""

DEPEND="virtual/libc"
RDEPEND="virtual/opengl"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself ${DISTDIR}/${MY_P} || die "unpacking game"
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	dodir ${dir}

	tar -zxf data.tar.gz -C ${Ddir}/ || die "armyops untar failed"
	tar -zxf music.tar.gz -C ${Ddir}/ || die "binaries untar failed"

	dodoc README
	newicon icon.xpm ${PN}.xpm || die "doins failed"
	exeinto ${dir}
	doexe bin/Linux/x86/glibc-2.1/mindrover_demo \
		bin/Linux/x86/glibc-2.1/lib/libopenal.so.0.0.6 || die "doexe failed"
	dosym ${dir}/libopenal.so.0.0.6 ${dir}/libopenal.so.0

	games_make_wrapper ${PN} ./mindrover_demo ${dir}

	prepgamesdirs
	make_desktop_entry ${PN} "Mindrover: Europa Project (Demo)" ${PN}.xpm
}
