# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/snes9x/snes9x-1.41.1.ebuild,v 1.3 2004/01/08 06:55:35 vapier Exp $

inherit games

MY_PV=1.41-1
DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="http://www.snes9x.com/"
SRC_URI="http://www.lysator.liu.se/snes9x/snes9x-${MY_PV}-src.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="3dfx opengl X joystick" # svga ggi

RDEPEND="sys-libs/zlib
	virtual/x11
	opengl? ( virtual/opengl )
	3dfx? ( media-libs/glide-v3 )"
#	X? ( virtual/x11 )
#	svga? ( media-libs/svgalib )
#	ggi? ( media-libs/libggi )
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

S=${WORKDIR}/${PN}-${MY_PV}-src

src_unpack() {
	unpack ${A}
	cd ${S}/snes9x
	epatch ${FILESDIR}/${PV}-system-zlib.patch
}

src_compile() {
	mkdir mybins
	cd snes9x
	local vidconf=
	local target=
	for vid in 3dfx opengl X ; do
		[ `use ${vid}` ] || continue
		case ${vid} in
			3dfx)
				vidconf="--with-glide --without-opengl --without-x"
				target=gsnes9x;;
			opengl)
				vidconf="--with-opengl --without-glide --without-x"
				target=osnes9x;;
			X)
				vidconf="--with-x --without-glide --without-opengl"
				target=snes9x;;
		esac
		# this stuff is ugly but hey the build process sucks ;)
		egamesconf \
			`use_with joystick` \
			${vidconf} \
			`use_with x86 assembler` \
			|| die
		emake ${target} || die "making ${target}"
		mv ${target} ${S}/mybins/
		cd ${WORKDIR}
		src_unpack
	done
}

src_install() {
	dodoc README.TXT README.UNIX
	dogamesbin mybins/*
	dodoc snes9x/{CHANGES,PROBLEMS,HARDWARE}.TXT
	prepgamesdirs
}
