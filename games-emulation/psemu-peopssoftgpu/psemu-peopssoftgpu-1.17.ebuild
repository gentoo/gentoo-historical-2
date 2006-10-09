# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/psemu-peopssoftgpu/psemu-peopssoftgpu-1.17.ebuild,v 1.5 2006/10/09 10:36:57 nyhm Exp $

inherit eutils games

DESCRIPTION="P.E.Op.S Software GPU plugin"
HOMEPAGE="http://sourceforge.net/projects/peops/"
SRC_URI="mirror://sourceforge/peops/PeopsSoftGpu${PV//./}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="sdl"

RDEPEND="=x11-libs/gtk+-1*
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x86? ( dev-lang/nasm )
	amd64? ( dev-lang/nasm )
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix src/makes/mk.fpse
	epatch \
		"${FILESDIR}"/${P}-makefile-cflags.patch \
		"${FILESDIR}"/${P}-fix-noxf86vm.patch \
		"${FILESDIR}"/${P}-gcc41.patch

	if [[ ${ARCH} != "x86" ]] ; then
		cd src
		sed -i \
			-e "s/^CPU = i386/CPU = ${ARCH}/g" \
			-e '/^XF86VM =/s:TRUE:FALSE:' makes/mk.x11 \
			|| die "sed non-x86 failed"
		if use sdl ; then
			sed -i \
				-e "s/OBJECTS.*i386.o//g" \
				-e "s/-D__i386__//g" makes/mk.fpse \
				|| die "sed sdl failed"
		fi
	fi
}

src_compile() {
	cd src
	emake OPTFLAGS="${CFLAGS}" || die "x11 build failed"

	# FIXME: this breaks if src_compile is called twice
	if use sdl ; then
		sed -i \
			-e 's:mk.x11:mk.fpse:g' Makefile \
			|| die "sed failed"
		make clean || die "make clean failed"
		emake OPTFLAGS="${CFLAGS}" || die "sdl build failed"
	fi
}

src_install() {
	dodoc *.txt
	insinto "${GAMES_LIBDIR}/psemu/cfg"
	doins gpuPeopsSoftX.cfg
	exeinto "${GAMES_LIBDIR}/psemu/plugins"
	doexe src/libgpuPeops* || die "doexe failed"
	exeinto "${GAMES_LIBDIR}/psemu/cfg"
	doexe src/cfgPeopsSoft || die "doexe failed"
	prepgamesdirs
}
