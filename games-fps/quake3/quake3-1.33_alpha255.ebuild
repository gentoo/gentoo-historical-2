# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3/quake3-1.33_alpha255.ebuild,v 1.2 2006/01/05 02:16:29 wolf31o2 Exp $

# quake3-9999          -> latest svn
# quake3-9999.REV      -> use svn REV
# quake3-VER_alphaREV  -> svn snapshot REV for version VER
# quake3-VER           -> normal quake release

if [[ ${PV} == 9999* ]] ; then
	[[ ${PV} == 9999.* ]] && ESVN_UPDATE_CMD="svn up -r ${PV/9999.}"
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
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated opengl"

RDEPEND="opengl? (
	virtual/opengl
	|| (
		(
			x11-libs/libXext
			x11-libs/libX11
			x11-libs/libXau
			x11-libs/libXdmcp )
		virtual/x11 )
	media-libs/libsdl )
	!dedicated? (
		virtual/opengl
		|| (
			(
				x11-libs/libXext
				x11-libs/libX11
				x11-libs/libXau
				x11-libs/libXdmcp )
			virtual/x11 )
		media-libs/libsdl )
	games-fps/quake3-data"

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }
	emake \
		BUILD_SERVER=$(buildit dedicated) \
		BUILD_CLIENT=$(buildit opengl) \
		TEMPDIR="${T}" \
		CC="$(tc-getCC)" \
		ARCH=$(tc-arch-kernel) \
		OPTIMIZE="${CFLAGS}" \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/quake3" \
		DEFAULT_LIBDIR="${GAMES_LIBDIR}/quake3" \
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

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "The source version of Quake 3 will not work with Punk Buster."
	ewarn "If you need pb support, then use the quake3-bin package."
	echo
}
