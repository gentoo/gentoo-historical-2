# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-demo/ut2004-demo-3120.ebuild,v 1.4 2004/02/15 07:14:54 brad_mssw Exp $

inherit games eutils

DESCRIPTION="Unreal Tournament 2004 Demo"
HOMEPAGE="http://www.unrealtournament.com/"

SRC_URI="x86? ( ftp://ftp.linuxhardware.org/ut2004/ut2004-lnx-demo-${PV}.run.bz2
	http://www.lokigames.com/sekrit/ut2004-lnx-demo-${PV}.run.bz2
	http://pomac.netswarm.net/mirror/games/ut2004/ut2004-lnx-demo-${PV}.run.bz2 )
	amd64? ( mirror://gentoo/ut2004-lnx64-demo-${PV}.run.bz2 )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86 amd64"

DEPEND="!dedicated? ( virtual/opengl )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	[ "${ARCH}" = "amd64" ] && RNAME="ut2004-lnx64-demo-${PV}.run"
	[ "${ARCH}" = "x86" ] && RNAME="ut2004-lnx-demo-${PV}.run"
	unpack_makeself ${RNAME}
	rm ${RNAME}
}

src_install() {
	local dir=/opt/${PN}
	dodir ${dir}

	tar -xf ut2004demo.tar -C ${D}/${dir}/ || die "unpacking ut2004 failed"

	insinto ${dir}
	doins README.linux ut2004demo.xpm

	exeinto ${dir}
	doexe bin/ut2004demo

	dodir ${GAMES_BINDIR}
	dosym ${dir}/ut2004demo ${GAMES_BINDIR}/ut2004demo

	prepgamesdirs
}
