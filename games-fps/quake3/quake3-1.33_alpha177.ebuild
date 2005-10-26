# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3/quake3-1.33_alpha177.ebuild,v 1.1 2005/10/26 00:29:12 vapier Exp $

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://svn.icculus.org/quake3/trunk"
	inherit subversion games toolchain-funcs

	SRC_URI=""
	S=${WORKDIR}/trunk
elif [[ ${PV} == *_alpha* ]] ; then
	inherit games toolchain-funcs

	MY_PV=${PV/_alpha*}
	SNAP=${PV/*_alpha}
	MY_P=${PN}-${MY_PV}_SVN${SNAP}M
	SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
	S=${WORKDIR}/${MY_P}
else
	inherit games toolchain-funcs

	SRC_URI="http://icculus.org/quake3/${P}.tar.bz2"
fi

DESCRIPTION="Quake III Arena - 3rd installment of the classic id 3D first-person shooter"
HOMEPAGE="http://icculus.org/quake3/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

RDEPEND="opengl? ( virtual/opengl virtual/x11 )
	games-fps/quake3-data"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
}

src_compile() {
	emake \
		TEMPDIR="${T}" \
		CC="$(tc-getCC)" \
		ARCH=$(tc-arch-kernel) \
		OPTIMIZE="${CFLAGS}" \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/quake3" \
		|| die
}

src_install() {
	dodoc id-readme.txt i_o-q3-readme
	cd code/unix
	dodoc ChangeLog README*

	doicon quake3.xpm
	make_desktop_entry quake3 "Quake III Arena" quake3.xpm

	cd release*
	for x in linux* ; do
		newgamesbin ${x} ${x/linux} || die "dobin ${x}"
	done
	exeinto ${GAMES_LIBDIR}/${PN}/baseq3
	doexe baseq3/*.so || die "baseq3 .so"
	exeinto ${GAMES_LIBDIR}/${PN}/missionpack
	doexe missionpack/*.so || die "missionpack .so"

	prepgamesdirs
}
